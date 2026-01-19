import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnhancedFloorCalculatorWidget extends StatelessWidget {
  final TextEditingController lengthController;
  final TextEditingController widthController;
  final String selectedUnit;
  final Function(String?) onUnitChanged;
  final ProductCalculatorConfig config;
  final SheetWidth? selectedWidth;
  final Function(SheetWidth?) onWidthChanged;
  final double calculatedArea;
  final int calculatedBoxes;
  final String calculationResult;

  const EnhancedFloorCalculatorWidget({
    super.key,
    required this.lengthController,
    required this.widthController,
    required this.selectedUnit,
    required this.onUnitChanged,
    required this.config,
    this.selectedWidth,
    required this.onWidthChanged,
    required this.calculatedArea,
    required this.calculatedBoxes,
    required this.calculationResult,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show calculator if disabled
    if (config.calculatorType == CalculatorType.disabled) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Calculator not available for this product',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // // Calculator header
          // Row(
          //   children: [
          //     Icon(Icons.calculate, size: 20.sp, color: Colors.blue[600]),
          //     SizedBox(width: 8.w),
          //     Text(
          //       'Flooring Calculator',
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black87,
          //       ),
          //     ),
          //   ],
          // ),

          // SizedBox(height: 16.h),

          // Length input (always visible)
          _buildLengthInput(),

          SizedBox(height: 12.h),

          // Width or Width Selection based on product type
          if (config.productType == ProductType.boxBased) ...[
            _buildWidthInput(),
          ] else if (config.productType == ProductType.carpet ||
              config.productType == ProductType.vinyl) ...[
            _buildWidthSelector(),
          ],

          SizedBox(height: 12.h),

          // Unit selector
          _buildUnitSelector(),

          SizedBox(height: 16.h),

          // Calculation explanation
          _buildCalculationExplanation(),

          SizedBox(height: 12.h),

          // Results
          if (calculationResult.isNotEmpty) _buildResults(),
        ],
      ),
    );
  }

  Widget _buildLengthInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Length',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Center(
            child: TextField(
              controller: lengthController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidthInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Width',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Center(
            child: TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidthSelector() {
    final availableWidths = config.availableWidths ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Width',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: availableWidths.map((width) {
              final isSelected = selectedWidth == width;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onWidthChanged(width),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[600] : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${width.width.toInt()}m',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelector() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Unit: $selectedUnit',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedUnit,
              isDense: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 16.sp,
                color: Colors.black87,
              ),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              items: ['Sqr. m.', 'Sqr. ft.'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 12.sp)),
                );
              }).toList(),
              onChanged: onUnitChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationExplanation() {
    String explanation = '';

    switch (config.productType) {
      case ProductType.boxBased:
        explanation =
            '• Room area calculated\n• ${config.wastePercentage}% waste added\n• Rounded up to full boxes';
        break;
      case ProductType.carpet:
      case ProductType.vinyl:
        explanation =
            '• Fixed width material\n• Length determines area\n• ${config.wastePercentage}% waste included';
        break;
      default:
        explanation = 'Standard calculation';
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.blue[100]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16.sp, color: Colors.blue[600]),
              SizedBox(width: 6.w),
              Text(
                'How we calculate:',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            explanation,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.blue[600],
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate_outlined,
                size: 20.sp,
                color: Colors.green[600],
              ),
              SizedBox(width: 8.w),
              Text(
                'Calculation Result',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Total area: ${calculatedArea.toStringAsFixed(2)} ${selectedUnit.toLowerCase()}',
            style: TextStyle(fontSize: 12.sp, color: Colors.green[600]),
          ),
          SizedBox(height: 4.h),
          Text(
            calculationResult,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}
