import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<AuthController>();

    return Obx(() {
      final mode = controller.forgotPasswordMode;

      // Choose which view to show based on mode
      switch (mode) {
        case ForgotPasswordMode.enterEmail:
          return _buildEnterEmailView(context, theme, controller);
        case ForgotPasswordMode.verifyCode:
          return _buildVerifyCodeView(context, theme, controller);
        case ForgotPasswordMode.resetPassword:
          return _buildResetPasswordView(context, theme, controller);
      }
    });
  }

  // Step 1: Enter Email
  Widget _buildEnterEmailView(
    BuildContext context,
    ThemeData theme,
    AuthController controller,
  ) {
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

  // Step 2: Verify Code
  Widget _buildVerifyCodeView(
    BuildContext context,
    ThemeData theme,
    AuthController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // Title
        Text(
          'Verify Code',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
          ),
        ),

        SizedBox(height: 12.h),

        // Subtitle
        Text(
          'We\'ve sent a 6-digit verification code to ${controller.emailController.text}. Please enter it below.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            height: 1.5,
          ),
        ),

        SizedBox(height: 32.h),

        // Verification Code Field
        CustomTextField(
          hintText: 'Verification Code',
          controller: controller.verificationCodeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          validator: controller.validateVerificationCode,
        ),

        SizedBox(height: 16.h),

        // Resend Code Button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () async {
              await controller.sendVerificationCode(
                controller.emailController.text,
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Resend Code',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        SizedBox(height: 32.h),

        // Verify Button
        CustomPrimaryButton(
          text: 'Verify',
          onPressed: () async {
            await controller.verifyCode(
              controller.verificationCodeController.text,
            );
          },
          isLoading: controller.isLoading,
        ),

        SizedBox(height: 24.h),
      ],
    );
  }

  // Step 3: Reset Password
  Widget _buildResetPasswordView(
    BuildContext context,
    ThemeData theme,
    AuthController controller,
  ) {
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
