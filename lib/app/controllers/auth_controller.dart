import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/views/screens/bottom_nav/app_nav_view.dart';

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

  // Form key
  final formKey = GlobalKey<FormState>();

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
    formKey.currentState?.reset();
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
    return formKey.currentState?.validate() ?? false;
  }

  // Sign in
  Future<void> signIn() async {
    if (!validateForm()) return;

    _isLoading.value = true;

    try {
      // TODO: Implement actual sign in logic
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Signed in successfully!',
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
        'Failed to sign in: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign up
  Future<void> signUp() async {
    if (!validateForm()) return;

    _isLoading.value = true;

    try {
      // TODO: Implement actual sign up logic
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Account created successfully!',
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
      // TODO: Implement actual email verification code sending
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Verification code sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
      );

      // Navigate to verify code screen
      goToVerifyCode();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification code: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
      // TODO: Implement actual code verification
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation - in real app, verify with backend
      if (code.length < 4) {
        Get.snackbar(
          'Error',
          'Invalid verification code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      Get.snackbar(
        'Success',
        'Code verified successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
      );

      // Navigate to reset password screen
      goToResetPassword();

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify code: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      // TODO: Implement actual password reset
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Success',
        'Password reset successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
      );

      // Clear forgot password fields
      clearForgotPasswordForm();

      // Switch back to sign in mode
      switchToSignIn();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reset password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
