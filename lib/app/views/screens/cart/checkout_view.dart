import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: Row(
          children: [
            SizedBox(width: 4.w),
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18.sp,
              ),
              padding: EdgeInsets.zero,
            ),
            Text(
              'Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        leadingWidth: 100.w,
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Review item before place your order',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Order summary card
                  Obx(
                    () => Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          // Product image
                          if (controller.cartItems.isNotEmpty)
                            Container(
                              width: 150.w,
                              height: 150.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.asset(
                                  controller.cartItems.first.imageAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          SizedBox(height: 20.h),

                          // Item details
                          if (controller.cartItems.isNotEmpty) ...[
                            _buildDetailRow(
                              'Item',
                              controller.cartItems.first.name,
                              isTitle: true,
                            ),
                            SizedBox(height: 12.h),
                            _buildDetailRow(
                              'Qty',
                              '${controller.cartItems.first.quantity} box',
                            ),
                            SizedBox(height: 12.h),
                            _buildDetailRow(
                              'Unit price',
                              '\$${controller.cartItems.first.price.toStringAsFixed(2)}',
                            ),
                          ],

                          SizedBox(height: 16.h),

                          // Subtotal
                          _buildDetailRow(
                            'Subtotal',
                            '\$${controller.subtotal.toStringAsFixed(2)}',
                            isBold: true,
                          ),

                          SizedBox(height: 12.h),

                          // Divider
                          Divider(color: Colors.grey[300], height: 1),

                          SizedBox(height: 12.h),

                          // Delivery fee
                          _buildDetailRow(
                            'Delivery fee',
                            '\$${controller.deliveryFee.toStringAsFixed(2)}',
                          ),

                          SizedBox(height: 12.h),

                          // Tax
                          _buildDetailRow(
                            'TAX',
                            '\$${controller.tax.toStringAsFixed(2)}',
                          ),

                          SizedBox(height: 16.h),

                          // Total
                          _buildDetailRow(
                            'Total',
                            '\$${controller.total.toStringAsFixed(2)}',
                            isBold: true,
                            isLarge: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Delivery address card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Deliver to',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Alex Morgan',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20.sp,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                '1248 Sunset View Dr, Apt 302, Los Angeles, CA 90026, USA',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(color: Colors.grey[300], height: 1),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18.sp,
                              color: Colors.grey[700],
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.h), // Space for button
                ],
              ),
            ),
          ),

          // Bottom button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle payment
                    Get.snackbar(
                      'Payment',
                      'Proceeding to payment...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3E50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to payment',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward, size: 20.sp),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    bool isLarge = false,
    bool isTitle = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 18.sp : 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isLarge ? 20.sp : (isTitle ? 16.sp : 14.sp),
              fontWeight: isBold || isTitle ? FontWeight.bold : FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
