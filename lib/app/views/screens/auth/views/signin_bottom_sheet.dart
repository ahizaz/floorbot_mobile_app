import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_text_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';

class SignInBottomSheet extends StatelessWidget {
   SignInBottomSheet({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final controller = Get.put(AuthController());

    return Container(
      height: mediaQuery.size.height * 0.92,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: theme.colorScheme.onSurface,
                        size: 20.sp,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Back',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        // Title
                        Text(
                          'Sign in to your DMS account',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 32.sp,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Email Field
                        CustomTextField(
                          hintText: 'Email',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateEmail,
                        ),

                        SizedBox(height: 20.h),

                        // Password Field
                        CustomTextField(
                          hintText: 'Password',
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: true,
                          showPasswordToggle: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await controller.signIn(validate: false);
                            }
                          },
                          validator: controller.validatePassword,
                        ),

                        SizedBox(height: 32.h),

                        // Sign In Button
                        CustomPrimaryButton(
                          text: 'Sign in',
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await controller.signIn(validate: false);
                            }
                          },
                          isLoading: controller.isLoading,
                        ),

                        SizedBox(height: 16.h),

                        // Create account link
                        Center(
                          child: CustomTextButton(
                            text: 'Create an account',
                            onPressed: () {
                              controller.switchToSignUp();
                              Navigator.pop(context);
                            },
                            textColor: theme.colorScheme.onSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Terms and Privacy Policy
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'By continue you\'re agree to DMS Flooring Supplies\'s ',
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle Terms of Service tap
                                      },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle Privacy Policy tap
                                      },
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
