import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_texts.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final String buttonText;
  final IconData? icon;

  const GlobeButton({
    super.key,
    this.onPressed,
    required this.isEnabled,
    required this.buttonText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) SizedBox(width: 8.w),
          Text(
            buttonText,
            style: AppTextsTheme.bodySmall.copyWith(color: Colors.white10),
          ),
        ],
      ),
    );
  }
}
