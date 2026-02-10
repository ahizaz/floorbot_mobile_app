import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/views/screens/bottom_nav/app_nav_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:floor_bot_mobile/app/controllers/signup_otp_controller.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/views/signup_otp_submit_view.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { signIn, signUp, forgotPassword }

enum ForgotPasswordMode { enterEmail, verifyCode, resetPassword }

class AuthController extends GetxController {
  // Observable auth mode
  final Rx<AuthMode> _authMode = AuthMode.signIn.obs;
  AuthMode get authMode => _authMode.value;

  // Observable forgot password mode
  final Rx<ForgotPasswordMode> _forgotPasswordMode =
      ForgotPasswordMode.enterEmail.obs;
  ForgotPasswordMode get forgotPasswordMode => _forgotPasswordMode.value;

  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Forgot password token
  String? _forgotPasswordToken;

  // Loading state
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Password visibility
  final RxBool _obscurePassword = true.obs;
  bool get obscurePassword => _obscurePassword.value;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access');
      debugPrint('AuthController.checkLoginStatus token: $token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      debugPrint('AuthController.checkLoginStatus error: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      EasyLoading.show(status: 'Logging out...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access');
      debugPrint('AuthController.logout: Token removed');
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Logged out successfully');
    } catch (e) {
      debugPrint('AuthController.logout error: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Failed to logout');
    }
  }

  // Switch between sign in and sign up
  void switchToSignIn() {
    _authMode.value = AuthMode.signIn;
    clearForm();
  }

  void switchToSignUp() {
    _authMode.value = AuthMode.signUp;
    clearForm();
  }

  void switchToForgotPassword() {
    _authMode.value = AuthMode.forgotPassword;
    _forgotPasswordMode.value = ForgotPasswordMode.enterEmail;
    clearForgotPasswordForm();
  }

  void toggleAuthMode() {
    if (_authMode.value == AuthMode.signIn) {
      switchToSignUp();
    } else {
      switchToSignIn();
    }
  }

  // Navigate between forgot password steps
  void goToVerifyCode() {
    _forgotPasswordMode.value = ForgotPasswordMode.verifyCode;
  }

  void goToResetPassword() {
    _forgotPasswordMode.value = ForgotPasswordMode.resetPassword;
  }

  void backFromForgotPassword() {
    if (_forgotPasswordMode.value == ForgotPasswordMode.enterEmail) {
      // Go back to sign in
      switchToSignIn();
    } else if (_forgotPasswordMode.value == ForgotPasswordMode.verifyCode) {
      // Go back to enter email
      _forgotPasswordMode.value = ForgotPasswordMode.enterEmail;
      verificationCodeController.clear();
    } else {
      // Go back to verify code
      _forgotPasswordMode.value = ForgotPasswordMode.verifyCode;
      newPasswordController.clear();
      confirmPasswordController.clear();
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  // Clear form
  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  // Clear forgot password form
  void clearForgotPasswordForm() {
    emailController.clear();
    verificationCodeController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  // Validate form
  bool validateForm() {
    // Validation is handled by the active form widget.
    // Keep this method for backward compatibility and default to true.
    return true;
  }

  Future<void> signIn({bool validate = true}) async {
    if (validate && !validateForm()) return;
    final email = emailController.text.trim();
    final password = passwordController.text;
    try {
      EasyLoading.show(status: 'please wait....');
      final body = jsonEncode({'username': email, 'password': password});
      debugPrint('AuthController.signIn URL : ${Urls.signIn}');
      debugPrint('AuthController.singnIn body :$body');
      final resp = await http
          .post(
            Uri.parse(Urls.signIn),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));
      debugPrint('AuthController.signIN status : ${resp.statusCode}');
      debugPrint('AuthController.singIn resp :${resp.body}');
      EasyLoading.dismiss();
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final parsed = jsonDecode(resp.body);
        final success = parsed['success'] == true;
        if (success) {
          final token = parsed['access'] ?? parsed['token'] ?? '';
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access', token);

          // Save user data from response
          if (parsed['user'] != null) {
            final user = parsed['user'];
            final userId = user['id'];
            final fullName = user['full_name'] ?? '';
            final image = user['image'];

            // Save user ID (can be int or String in response)
            if (userId is int) {
              await prefs.setInt('user_id', userId);
            } else if (userId is String) {
              await prefs.setInt('user_id', int.parse(userId));
            }

            // Save user profile info
            if (fullName.isNotEmpty) {
              await prefs.setString('full_name', fullName);
            }
            if (image != null && image.toString().isNotEmpty) {
              await prefs.setString('image', image.toString());
            }

            debugPrint('AuthController: ✅ Saved User ID: $userId');
            debugPrint('AuthController: ✅ Saved User Name: $fullName');
            debugPrint('AuthController: ✅ Saved User Image: $image');
          }

          EasyLoading.showSuccess(parsed['message'] ?? 'Login successful!');
          clearForm();
          Get.offAll(() => const AppNavView());
          return;
        }
      }
      String message = resp.body;
      try {
        final parsed = jsonDecode(resp.body);
        message = parsed['message'] ?? parsed['error'] ?? resp.body;
      } catch (_) {}
      EasyLoading.showError(message);
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('AuthController.signIn error: $e');
      EasyLoading.showError('Failed to sign in: ${e.toString()}');
    }
  }

  // Sign up
  Future<void> signUp({bool validate = true}) async {
    if (validate && !validateForm()) return;

    _isLoading.value = true;

    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      EasyLoading.show(status: 'Please wait...');

      final body = jsonEncode({
        'username': email,
        'full_name': fullName,
        'email': email,
        'password': password,
      });

      debugPrint('AuthController.signUp URL: ${Urls.signUp}');
      debugPrint('AuthController.signUp body: $body');

      final resp = await http
          .post(
            Uri.parse(Urls.signUp),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('AuthController.signUp status: ${resp.statusCode}');
      debugPrint('AuthController.signUp resp: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Colors.white,
        );

        final otpController = SignUpOtpController(initialEmail: email);
        await otpController.sendVerificationCode(email);

        try {
          Get.back();
        } catch (_) {}

        Get.bottomSheet(
          Container(
            height: Get.height * 0.92,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: SignUpOtp(controller: otpController),
                ),
              ),
            ),
          ),
          isScrollControlled: true,
        );

        clearForm();
      } else {
        String message = resp.body;
        try {
          final parsed = jsonDecode(resp.body);
          message = parsed['message'] ?? parsed['error'] ?? resp.body;
        } catch (_) {}

        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Failed to create account: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    _isLoading.value = true;

    try {
      // TODO: Implement Google sign in
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Signed in with Google successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
      );

      // Navigate to dashboard with bottom navigation
      Get.offAll(() => const AppNavView());
      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Validators
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Forgot Password Flow

  // Step 1: Send verification code to email
  Future<void> sendVerificationCode(String email) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final emailError = validateEmail(email);
    if (emailError != null) {
      Get.snackbar(
        'Error',
        emailError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    try {
      EasyLoading.show(status: 'Please wait...');

      final body = jsonEncode({'email': email});

      debugPrint(
        'AuthController.sendVerificationCode URL: ${Urls.forgetPassword}',
      );
      debugPrint('AuthController.sendVerificationCode body: $body');

      final resp = await http
          .post(
            Uri.parse(Urls.forgetPassword),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint(
        'AuthController.sendVerificationCode status: ${resp.statusCode}',
      );
      debugPrint('AuthController.sendVerificationCode resp: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final parsed = jsonDecode(resp.body);
        final success = parsed['success'] == true;

        if (success) {
          EasyLoading.showSuccess(
            parsed['message'] ?? 'Verification code sent to $email',
          );
          // Navigate to verify code screen
          goToVerifyCode();
          return;
        }
      }

      String message = resp.body;
      try {
        final parsed = jsonDecode(resp.body);
        message = parsed['message'] ?? parsed['error'] ?? resp.body;
      } catch (_) {}

      EasyLoading.showError(message);
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('AuthController.sendVerificationCode error: $e');
      EasyLoading.showError(
        'Failed to send verification code: ${e.toString()}',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Step 2: Verify the code
  Future<bool> verifyCode(String code) async {
    if (code.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter verification code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    _isLoading.value = true;

    try {
      EasyLoading.show(status: 'Please wait...');

      final email = emailController.text.trim();
      final body = jsonEncode({'otp': code});

      debugPrint(
        'AuthController.verifyCode URL: ${Urls.forgetPasswordOtp(email)}',
      );
      debugPrint('AuthController.verifyCode body: $body');

      final resp = await http
          .post(
            Uri.parse(Urls.forgetPasswordOtp(email)),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('AuthController.verifyCode status: ${resp.statusCode}');
      debugPrint('AuthController.verifyCode resp: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final parsed = jsonDecode(resp.body);
        final success = parsed['success'] == true;

        if (success) {
          // Store the token for reset password
          _forgotPasswordToken = parsed['access'] ?? parsed['token'];
          debugPrint(
            'AuthController.verifyCode token stored: $_forgotPasswordToken',
          );

          EasyLoading.showSuccess(
            parsed['message'] ?? 'Code verified successfully',
          );
          // Navigate to reset password screen
          goToResetPassword();
          return true;
        }
      }

      String message = resp.body;
      try {
        final parsed = jsonDecode(resp.body);
        message = parsed['message'] ?? parsed['error'] ?? resp.body;
      } catch (_) {}

      EasyLoading.showError(message);
      return false;
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('AuthController.verifyCode error: $e');
      EasyLoading.showError('Failed to verify code: ${e.toString()}');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Step 3: Reset password
  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final passwordError = validatePassword(newPassword);
    if (passwordError != null) {
      Get.snackbar(
        'Error',
        passwordError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    try {
      EasyLoading.show(status: 'Please wait...');

      final body = jsonEncode({'new_password': newPassword});

      debugPrint('AuthController.resetPassword URL: ${Urls.resetPassword}');
      debugPrint('AuthController.resetPassword body: $body');
      debugPrint('AuthController.resetPassword token: $_forgotPasswordToken');

      final resp = await http
          .post(
            Uri.parse(Urls.resetPassword),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_forgotPasswordToken',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('AuthController.resetPassword status: ${resp.statusCode}');
      debugPrint('AuthController.resetPassword resp: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final parsed = jsonDecode(resp.body);
        final success = parsed['success'] == true;

        if (success) {
          EasyLoading.showSuccess(
            parsed['message'] ?? 'Password reset successfully!',
          );

          // Clear the token
          _forgotPasswordToken = null;

          // Clear forgot password fields
          clearForgotPasswordForm();

          // Switch back to sign in mode
          switchToSignIn();
          return;
        }
      }

      String message = resp.body;
      try {
        final parsed = jsonDecode(resp.body);
        message = parsed['message'] ?? parsed['error'] ?? resp.body;
      } catch (_) {}

      EasyLoading.showError(message);
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('AuthController.resetPassword error: $e');
      EasyLoading.showError('Failed to reset password: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  // Validator for confirmation password
  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Validator for verification code
  String? validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter verification code';
    }
    if (value.length < 4) {
      return 'Verification code must be at least 4 characters';
    }
    return null;
  }
}
