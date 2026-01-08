import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:floor_bot_mobile/app/core/utils/utils.dart';

class SettingsBottomWidget extends StatelessWidget {
  final VoidCallback onAccountSettings;
  final VoidCallback onSecurity;
  final VoidCallback onSupport;
  final VoidCallback onTerms;

  const SettingsBottomWidget({
    super.key,
    required this.onAccountSettings,
    required this.onSecurity,
    required this.onSupport,
    required this.onTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Curved background SVG at the bottom
        SvgPicture.asset(Utils.settingsBG, fit: BoxFit.fill, width: Get.width),

        // Settings card positioned on top of the curved background
        Positioned(
          top: 20.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingItem(
                  icon: Icons.person_outline,
                  title: 'Account settings',
                  subtitle: 'Edit display name, contact & delivery address',
                  onTap: onAccountSettings,
                ),
                Divider(height: 1.h, color: Colors.grey[200]),
                _buildSettingItem(
                  icon: Icons.lock_outline,
                  title: 'Security',
                  subtitle: 'Change your email & password.',
                  onTap: onSecurity,
                ),
                Divider(height: 1.h, color: Colors.grey[200]),
                _buildSettingItem(
                  icon: Icons.support_agent_outlined,
                  title: 'Support',
                  subtitle: 'LIVE chat with admin',
                  onTap: onSupport,
                ),
                Divider(height: 1.h, color: Colors.grey[200]),
                _buildSettingItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of service',
                  subtitle: 'Last updated June 17, 2025',
                  onTap: onTerms,
                  showArrow: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.sp, color: Colors.black87),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }
}
