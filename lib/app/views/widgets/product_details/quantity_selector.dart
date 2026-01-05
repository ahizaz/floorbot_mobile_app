import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function(String)? onChanged;

  const QuantitySelector({
    super.key,
    required this.controller,
    required this.onIncrement,
    required this.onDecrement,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ),
              Container(width: 1, height: 56.h, color: Colors.grey[300]),
              SizedBox(
                width: 56.w,
                child: IconButton(
                  onPressed: onDecrement,
                  icon: Icon(
                    Icons.remove,
                    color: Colors.grey[700],
                    size: 20.sp,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              Container(width: 1, height: 56.h, color: Colors.grey[300]),
              SizedBox(
                width: 56.w,
                child: IconButton(
                  onPressed: onIncrement,
                  icon: Icon(Icons.add, color: Colors.grey[700], size: 20.sp),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
