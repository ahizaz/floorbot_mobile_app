import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_themes.dart';
import 'package:floor_bot_mobile/app/views/screens/initial_view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize currency controller
    Get.put(CurrencyController());

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Floor Bot Mobile',
          theme: AppThemes.lightTheme(),
          darkTheme: AppThemes.darkTheme(),
          themeMode: ThemeMode.system,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
