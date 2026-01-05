import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloorCalculatorWidget extends StatelessWidget {
  final TextEditingController lengthController;
  final TextEditingController widthController;
  final String selectedUnit;
  final Function(String?) onUnitChanged;
  final String productSize;
  final int quantity;
  final int calculatedBoxes;

  const FloorCalculatorWidget({
    super.key,
    required this.lengthController,
    required this.widthController,
    required this.selectedUnit,
    required this.onUnitChanged,
    required this.productSize,
    required this.quantity,
    required this.calculatedBoxes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Length, Width, Unit Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Length input
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Length',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 70.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Center(
                      child: TextField(
                        controller: lengthController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: '0',
                          hintStyle: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Width input
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Width',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 70.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Center(
                      child: TextField(
                        controller: widthController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: '0',
                          hintStyle: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Unit dropdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 70.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedUnit,
                        isExpanded: true,
                        isDense: false,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 24.sp,
                          color: Colors.black87,
                        ),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        items: ['Sqr. m.', 'Sqr. ft.'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: onUnitChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Product size
        Text(
          'Product size: $productSize',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 4.h),

        // Quantity
        Text(
          'Quantity: $quantity pcs',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 8.h),

        // Result
        if (calculatedBoxes > 0)
          Text(
            'You\'ll need $calculatedBoxes box',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blue[600],
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
