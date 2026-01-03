import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/views/forgot_password_enter_email_view.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/views/forgot_password_verify_code_view.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/views/forgot_password_reset_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Obx(() {
      final mode = controller.forgotPasswordMode;

      // Choose which view to show based on mode
      switch (mode) {
        case ForgotPasswordMode.enterEmail:
          return ForgotPasswordEnterEmailView(controller: controller);
        case ForgotPasswordMode.verifyCode:
          return ForgotPasswordVerifyCodeView(controller: controller);
        case ForgotPasswordMode.resetPassword:
          return ForgotPasswordResetView(controller: controller);
      }
    });
  }
}
