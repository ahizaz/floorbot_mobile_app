import 'package:floor_bot_mobile/app/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CurrencySettingsWidget extends StatelessWidget {
  const CurrencySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Container(
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
                Icons.currency_exchange,
                size: 24.sp,
                color: Colors.blue[600],
              ),
              SizedBox(width: 12.w),
              Text(
                'Currency',
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
            'Select your preferred currency for displaying prices:',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),

          SizedBox(height: 16.h),

          Obx(() {
            return Column(
              children: controller.availableCurrencies.map((currency) {
                final isSelected = controller.currentCurrency == currency;

                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  child: InkWell(
                    onTap: () => controller.changeCurrency(currency),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue[50]
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue[300]!
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? Colors.blue[600]
                                : Colors.grey[400],
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              controller.getCurrencyDisplayName(currency),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.blue[700]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (currency == 'GBP')
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          SizedBox(height: 12.h),

          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.amber[200]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16.sp, color: Colors.amber[700]),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Exchange rates are approximate and for display purposes only.',
                    style: TextStyle(fontSize: 11.sp, color: Colors.amber[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
