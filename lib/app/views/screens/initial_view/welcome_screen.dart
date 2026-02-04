import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_texts.dart';
import 'package:floor_bot_mobile/app/controllers/auth_controller.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_primary_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_outlined_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/buttons/custom_text_button.dart';
import 'package:floor_bot_mobile/app/views/widgets/common/or_divider.dart';
import 'package:floor_bot_mobile/app/views/screens/auth/views/auth_bottom_sheet.dart';
import 'package:floor_bot_mobile/app/views/screens/bottom_nav/app_nav_view.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authController = Get.put(AuthController());
    final isLoggedIn = await authController.checkLoginStatus();
    if (isLoggedIn && mounted) {
      Get.offAll(() => const AppNavView());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with dark background
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    SvgPicture.asset('assets/svgs/app_logo.svg', height: 50.h),
                    SizedBox(height: 40.h),

                    // Illustration
                    SvgPicture.asset(
                      'assets/svgs/welcome_animate.svg',
                      height: 280.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom section with white background
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(30.r),
                  //   topRight: Radius.circular(30.r),
                  // ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Your Trade Partner.',
                        style: AppTextsTheme.headlineMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Anytime. Anywhere',
                        style: AppTextsTheme.headlineMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 32.h),

                      // Continue with Google Button
                      CustomOutlinedButton(
                        text: 'Continue with Google',
                        onPressed: () {
                          final authController = Get.put(AuthController());
                          authController.signInWithGoogle();
                        },
                        leadingIcon: SvgPicture.asset(
                          'assets/svgs/google_icon.svg',
                          width: 24.w,
                          height: 24.h,
                        ),
                        borderColor: Colors.grey[300],
                        textColor: theme.colorScheme.onSurface,
                      ),

                      SizedBox(height: 20.h),

                      // Or Divider
                      const OrDivider(),

                      SizedBox(height: 20.h),

                      // Sign in Button
                      CustomPrimaryButton(
                        text: 'Sign in',
                        onPressed: () {
                          Get.bottomSheet(
                            const AuthBottomSheet(initialMode: AuthMode.signIn),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),

                      SizedBox(height: 16.h),

                      // Create an account Button
                      CustomTextButton(
                        text: '+ Create an account',
                        onPressed: () {
                          Get.bottomSheet(
                            const AuthBottomSheet(initialMode: AuthMode.signUp),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                        textColor: theme.colorScheme.onSurface,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
