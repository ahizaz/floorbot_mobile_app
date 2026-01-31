// lib/app/controllers/sign_up_otp_controller.dart

import 'package:flutter/material.dart';

class SignUpOtpController extends ChangeNotifier {
  final TextEditingController emailController;
  final TextEditingController verificationCodeController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SignUpOtpController({String? initialEmail})
      : emailController = TextEditingController(text: initialEmail ?? '');

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> sendVerificationCode(String email) async {
    _setLoading(true);
    try {
    
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Returns true on successful verification.
  Future<bool> verifyCode(String code) async {
    _setLoading(true);
    try {
      // TODO: Replace with your API call to verify OTP
      await Future.delayed(const Duration(seconds: 1));
      // Example stub: accept any non-empty code as success (change for real)
      return code.trim().isNotEmpty;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }
}