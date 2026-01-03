import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';

class ForgotPasswordResetView extends StatelessWidget {
  final AuthController controller;

  const ForgotPasswordResetView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // Title
        Text(
          'Reset Password',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
          ),
        ),

        SizedBox(height: 12.h),

        // Subtitle
        Text(
          'Create a new password for your account. Make sure it\'s strong and secure.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),

        SizedBox(height: 32.h),

        // New Password Field
        CustomTextField(
          hintText: 'New Password',
          controller: controller.newPasswordController,
          isPassword: true,
          textInputAction: TextInputAction.next,
          validator: controller.validatePassword,
          showPasswordToggle: true,
        ),

        SizedBox(height: 20.h),

        // Confirm Password Field
        CustomTextField(
          hintText: 'Confirm Password',
          controller: controller.confirmPasswordController,
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: (value) => controller.validateConfirmPassword(
            value,
            controller.newPasswordController.text,
          ),
          showPasswordToggle: true,
        ),

        SizedBox(height: 32.h),

        // Reset Password Button
        CustomPrimaryButton(
          text: 'Reset Password',
          onPressed: () async {
            await controller.resetPassword(
              controller.newPasswordController.text,
              controller.confirmPasswordController.text,
            );
          },
          isLoading: controller.isLoading,
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
