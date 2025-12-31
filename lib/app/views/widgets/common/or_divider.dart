import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final Color? lineColor;
  final Color? textColor;
  final double? thickness;

  const OrDivider({
    super.key,
    this.text = 'Or',
    this.lineColor,
    this.textColor,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: lineColor ?? theme.dividerColor.withOpacity(0.2),
            thickness: thickness ?? 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface.withOpacity(0.2),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: lineColor ?? theme.dividerColor.withOpacity(0.2),
            thickness: thickness ?? 1,
          ),
        ),
      ],
    );
  }
}
