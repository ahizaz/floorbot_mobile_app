import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountSettingsBottomSheet extends StatefulWidget {
  const AccountSettingsBottomSheet({super.key});

  @override
  State<AccountSettingsBottomSheet> createState() =>
      _AccountSettingsBottomSheetState();
}

class _AccountSettingsBottomSheetState
    extends State<AccountSettingsBottomSheet> {
  // Controllers for personal details
  final _displayNameController = TextEditingController(text: 'Alex Morgan');
  final _emailController = TextEditingController(
    text: 'alexmorgan97@gmail.com',
  );
  final _phoneController = TextEditingController();

  // Controllers for delivery address
  final _streetController = TextEditingController(text: '1903 W Michigan Ave');
  final _cityController = TextEditingController(text: 'Kalamazoo');
  final _zipController = TextEditingController(text: '49008-5347');
  final _countryController = TextEditingController(text: 'United States');

  // Save handler
  void _handleSave() {
    Get.snackbar(
      'Success',
      'Changes saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Header with back button and save button
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 18.sp,
                          color: Colors.black,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Save button
                  GestureDetector(
                    onTap: _handleSave,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Account settings',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    'Edit your personal information, contact number and delivery address.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // PERSONAL DETAILS Section
                  Text(
                    'PERSONAL DETAILS',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Display Name
                  _buildEditableField(
                    label: 'Display Name',
                    controller: _displayNameController,
                    enabled: true,
                  ),
                  SizedBox(height: 20.h),

                  // Email
                  _buildEditableField(
                    label: 'Email',
                    controller: _emailController,
                    enabled: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),

                  // Phone
                  _buildEditableField(
                    label: 'Phone',
                    controller: _phoneController,
                    enabled: true,
                    placeholder: 'Add your valid phone number',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 32.h),

                  // DELIVERY ADDRESS Section
                  Text(
                    'DELIVERY ADDRESS',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Street
                  _buildEditableField(
                    label: 'Street',
                    controller: _streetController,
                    enabled: true,
                  ),
                  SizedBox(height: 20.h),

                  // City
                  _buildEditableField(
                    label: 'City',
                    controller: _cityController,
                    enabled: true,
                  ),
                  SizedBox(height: 20.h),

                  // ZIP
                  _buildEditableField(
                    label: 'ZIP',
                    controller: _zipController,
                    enabled: true,
                  ),
                  SizedBox(height: 20.h),

                  // Country
                  _buildEditableField(
                    label: 'Country',
                    controller: _countryController,
                    enabled: true,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    String? placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
              ),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
