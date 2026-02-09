import 'package:floor_bot_mobile/app/controllers/shipping_address_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/themes/app_colors.dart';
import 'package:floor_bot_mobile/app/views/widgets/inputs/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShippingAddressController());

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
          'Shipping Address',
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
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Information',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Please provide your delivery address details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Full Name
                    CustomTextField(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      controller: controller.fullNameController,
                      prefixIcon: Icon(Icons.person_outline),
                      validator: controller.validateFullName,
                    ),

                    SizedBox(height: 16.h),

                    // Phone Number
                    CustomTextField(
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      controller: controller.phoneController,
                      prefixIcon: Icon(Icons.phone_outlined),
                      keyboardType: TextInputType.phone,
                      validator: controller.validatePhone,
                    ),

                    SizedBox(height: 16.h),

                    // Address Line 1
                    CustomTextField(
                      labelText: 'Address Line 1',
                      hintText: 'House number and street name',
                      controller: controller.addressLine1Controller,
                      prefixIcon: Icon(Icons.home_outlined),
                      validator: controller.validateAddress,
                    ),

                    SizedBox(height: 16.h),

                    // Address Line 2 (Optional)
                    CustomTextField(
                      labelText: 'Address Line 2 (Optional)',
                      hintText: 'Apartment, suite, unit, etc.',
                      controller: controller.addressLine2Controller,
                      prefixIcon: Icon(Icons.apartment_outlined),
                    ),

                    SizedBox(height: 16.h),

                    // City and Postal Code Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            labelText: 'City',
                            hintText: 'Enter city',
                            controller: controller.cityController,
                            prefixIcon: Icon(Icons.location_city_outlined),
                            validator: controller.validateCity,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomTextField(
                            labelText: 'Postal Code',
                            hintText: 'ZIP code',
                            controller: controller.postalCodeController,
                            prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                            keyboardType: TextInputType.text,
                            validator: controller.validatePostalCode,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // State and Country Row
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            labelText: 'State/County',
                            hintText: 'Enter state',
                            controller: controller.stateController,
                            prefixIcon: Icon(Icons.map_outlined),
                            validator: controller.validateState,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: CustomTextField(
                            labelText: 'Country',
                            hintText: 'Enter country',
                            controller: controller.countryController,
                            prefixIcon: Icon(Icons.public_outlined),
                            validator: controller.validateCountry,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Delivery Instructions (Optional)
                    CustomTextField(
                      labelText: 'Delivery Instructions (Optional)',
                      hintText: 'Any special instructions for delivery...',
                      controller: controller.deliveryInstructionsController,
                      prefixIcon: Icon(Icons.note_outlined),
                      maxLines: 3,
                    ),

                    SizedBox(height: 24.h),

                    // Save address for future orders checkbox
                    Obx(
                      () => CheckboxListTile(
                        value: controller.saveAddress.value,
                        onChanged: (value) {
                          controller.saveAddress.value = value ?? false;
                        },
                        title: Text(
                          'Save this address for future orders',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 100.h), // Space for button
                  ],
                ),
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
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveShippingAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save Address & Continue',
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
          ),
        ],
      ),
    );
  }
}
