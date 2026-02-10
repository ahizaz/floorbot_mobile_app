import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_text_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/views/forgot_password_view.dart';

class AuthBottomSheet extends StatefulWidget {
  final AuthMode initialMode;

  const AuthBottomSheet({super.key, this.initialMode = AuthMode.signIn});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set initial mode after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.put(AuthController());
      if (widget.initialMode == AuthMode.signIn) {
        controller.switchToSignIn();
      } else {
        controller.switchToSignUp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    // Get or create controller
    final controller = Get.put(AuthController());

    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.95),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with back button
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: theme.colorScheme.onSurface,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      // Handle back button based on mode
                      if (controller.authMode == AuthMode.forgotPassword) {
                        controller.backFromForgotPassword();
                      } else {
                        controller.clearForm();
                        Get.back();
                      }
                    },
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
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24.w,
                8.h,
                24.w,
                24.h + mediaQuery.padding.bottom,
              ),
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Obx(() {
                // If in forgot password mode, show ForgotPasswordView
                if (controller.authMode == AuthMode.forgotPassword) {
                  return const ForgotPasswordView();
                }

                // Otherwise show sign in/sign up form
                final isSignIn = controller.authMode == AuthMode.signIn;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      // Title
                      Text(
                        isSignIn
                            ? 'Sign in to your DMS account'
                            : 'Create your DMS account',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          height: 1.3,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Full Name Field (only for sign up)
                      if (!isSignIn) ...[
                        CustomTextField(
                          hintText: 'Full Name',
                          controller: controller.fullNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: controller.validateFullName,
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Email Field
                      CustomTextField(
                        hintText: 'Email',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: controller.validateEmail,
                      ),

                      SizedBox(height: 16.h),

                      // Password Field
                      CustomTextField(
                        hintText: 'Password',
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        showPasswordToggle: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          if (isSignIn) {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.signIn(validate: false);
                            }
                          } else {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.signUp(validate: false);
                            }
                          }
                        },
                        validator: controller.validatePassword,
                      ),

                      // Forgot Password Link (only for sign in)
                      if (isSignIn) ...[
                        SizedBox(height: 12.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              controller.switchToForgotPassword();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ] else ...[
                        SizedBox(height: 20.h),
                      ],

                      // Primary Action Button
                      CustomPrimaryButton(
                        text: isSignIn ? 'Sign in' : 'Continue',
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (isSignIn) {
                              await controller.signIn(validate: false);
                            } else {
                              await controller.signUp(validate: false);
                            }
                          }
                        },
                        isLoading: controller.isLoading,
                      ),

                      SizedBox(height: 16.h),

                      // Toggle Action Link
                      Center(
                        child: CustomTextButton(
                          text: isSignIn ? 'Create an account' : 'Sign in',
                          onPressed: controller.toggleAuthMode,
                          textColor: theme.colorScheme.onSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Terms and Privacy Policy
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
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
                );
              }),
            ),
          ),
        ],
      ),
    )
    ;
    
  }
}
