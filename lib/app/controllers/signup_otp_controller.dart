// lib/app/controllers/sign_up_otp_controller.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';

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
      final email = emailController.text.trim();
      final body = jsonEncode({'otp': code});
      debugPrint('Verify OTP URL: ${Urls.signUpOtp(email)}');
      debugPrint('Verify OTP body: $body');

      EasyLoading.show(status: 'Verifying...');

      final resp = await http
          .post(Uri.parse(Urls.signUpOtp(email)),
              headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 30));

      debugPrint('Verify OTP status: ${resp.statusCode}');
      debugPrint('Verify OTP resp: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        EasyLoading.showSuccess('Account verified successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      EasyLoading.dismiss();
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