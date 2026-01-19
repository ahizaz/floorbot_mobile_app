import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/views/widgets/settings/currency_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency Settings
            const CurrencySettingsWidget(),

            SizedBox(height: 20.h),

            // Other settings can be added here
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 24.sp,
                        color: Colors.blue[600],
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    'Floor Bot Mobile - Your flooring solution app',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'Features:',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        [
                              '• GBP currency as default (UK-based)',
                              '• Smart flooring calculator',
                              '• Box-based product calculations',
                              '• Sheet-based calculations (Carpet/Vinyl)',
                              '• 5% waste calculation included',
                              '• Currency conversion support',
                            ]
                            .map(
                              (feature) => Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
