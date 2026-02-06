import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/controllers/profile_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/views/screens/shipping/shipping_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final profileController = Get.find<ProfileController>();

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
                                child: _buildCartItemImage(
                                  controller.cartItems.first,
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
                        // Text(
                        //   'Alex Morgan',
                        //   style: TextStyle(
                        //     fontSize: 16.sp,
                        //     fontWeight: FontWeight.w600,
                        //     color: Colors.black87,
                        //   ),
                        // ),
                        Obx(
                          () => Text(
                            profileController.profileData.value?.fullName ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
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
                              child: Obx(() {
                                final profile =
                                    profileController.profileData.value;

                                // Build address string from API data
                                final addressParts = <String>[];

                                if (profile?.addressLineI != null &&
                                    profile!.addressLineI!.isNotEmpty) {
                                  addressParts.add(profile.addressLineI!);
                                }
                                if (profile?.suburb != null &&
                                    profile!.suburb!.isNotEmpty) {
                                  addressParts.add(profile.suburb!);
                                }
                                if (profile?.city != null &&
                                    profile!.city!.isNotEmpty) {
                                  addressParts.add(profile.city!);
                                }
                                if (profile?.countryOrRegion != null &&
                                    profile!.countryOrRegion!.isNotEmpty) {
                                  addressParts.add(profile.countryOrRegion!);
                                }
                                if (profile?.postalCode != null &&
                                    profile!.postalCode!.isNotEmpty) {
                                  addressParts.add(profile.postalCode!);
                                }

                                final address = addressParts.isNotEmpty
                                    ? addressParts.join(', ')
                                    : '1248 Sunset View Dr, Apt 302, Los Angeles, CA 90026, USA';

                                return Text(
                                  address,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                );
                              }),
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
                            GestureDetector(
                              onTap: () async {
                                final result = await Get.to(
                                  () => const ShippingAddressScreen(),
                                  transition: Transition.cupertino,
                                );
                                if (result != null) {
                                  // Handle updated address
                                  Get.snackbar(
                                    'Address Updated',
                                    'Your delivery address has been updated.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                              child: Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
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
              child: ElevatedButton(
                onPressed: () {},
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
                    Icon(Icons.check_circle_outline, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Go For Payment',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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

  Widget _buildCartItemImage(dynamic item) {
    final imageUrl = item.imageUrl;
    final imageAsset = item.imageAsset;

    String? fullImageUrl;
    if (imageUrl != null) {
      if (imageUrl.startsWith('http')) {
        fullImageUrl = imageUrl;
      } else {
        final baseUrlWithoutApi = 'http://10.10.12.15:8089';
        fullImageUrl = '$baseUrlWithoutApi$imageUrl';
      }
    }

    if (fullImageUrl != null) {
      return Image.network(
        fullImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image, size: 60.sp, color: Colors.grey);
        },
      );
    } else if (imageAsset != null) {
      return Image.asset(
        imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image, size: 60.sp, color: Colors.grey);
        },
      );
    }

    return Icon(Icons.image, size: 60.sp, color: Colors.grey);
  }
}
