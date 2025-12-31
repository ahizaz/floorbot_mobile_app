import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_text_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';

class SignUpBottomSheet extends StatefulWidget {
  const SignUpBottomSheet({super.key});

  @override
  State<SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends State<SignUpBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle sign up
      Navigator.pop(context);
    }
  }

  void _handleSignIn() {
    Navigator.pop(context);
    // Navigate to sign in screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.92,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 8.h),

                        // Title
                        Text(
                          'Create your DMS account',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 32.sp,
                          ),
                        ),

                        SizedBox(height: 15.h),

                        // Full Name Field
                        CustomTextField(
                          hintText: 'Full Name',
                          controller: _fullNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10.h),

                        // Email Field
                        CustomTextField(
                          hintText: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10.h),

                        // Password Field
                        CustomTextField(
                          hintText: 'Password',
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: true,
                          showPasswordToggle: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleContinue(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 32.h),

                        // Continue Button
                        CustomPrimaryButton(
                          text: 'Continue',
                          onPressed: _handleContinue,
                        ),

                        SizedBox(height: 16.h),

                        // Sign in link
                        Center(
                          child: CustomTextButton(
                            text: 'Sign in',

                            onPressed: _handleSignIn,
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
