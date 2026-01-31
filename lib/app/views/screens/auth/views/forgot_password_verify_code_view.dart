import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/pin_input_field.dart';

class ForgotPasswordVerifyCodeView extends StatelessWidget {
  final AuthController controller;

  const ForgotPasswordVerifyCodeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

        SizedBox(height: 40.h),

        // PIN Input Field
        PinInputField(
          pinLength: 6,
          onCompleted: (pin) {
            // Automatically verify when all 6 digits are entered
            controller.verificationCodeController.text = pin;
          },
          onChanged: (pin) {
            // Update the controller as user types
            controller.verificationCodeController.text = pin;
          },
        ),

        SizedBox(height: 24.h),

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
}
