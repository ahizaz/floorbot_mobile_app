import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';

class ForgotPasswordEnterEmailView extends StatelessWidget {
  final AuthController controller;

  const ForgotPasswordEnterEmailView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // Title
        Text(
          'Forgot Password?',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
          ),
        ),

        SizedBox(height: 12.h),

        // Subtitle
        Text(
          'Enter your email address and we\'ll send you a verification code to reset your password.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),

        SizedBox(height: 32.h),

        // Email Field
        CustomTextField(
          hintText: 'Email',
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: controller.validateEmail,
        ),

        SizedBox(height: 32.h),

        // Send Code Button
        CustomPrimaryButton(
          text: 'Send Code',
          onPressed: () async {
            await controller.sendVerificationCode(
              controller.emailController.text,
            );
          },
          isLoading: controller.isLoading,
        ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
