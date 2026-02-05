import 'dart:convert';
import 'package:floor_bot_mobile/app/controllers/profile_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress {
  final String fullName;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String deliveryInstructions;

  ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.deliveryInstructions,
  });

  String get formattedAddress {
    final parts = <String>[];

    parts.add(fullName);
    parts.add(addressLine1);
    if (addressLine2.isNotEmpty) parts.add(addressLine2);
    parts.add('$city, $state $postalCode');
    parts.add(country);

    return parts.join('\n');
  }
}

class ShippingAddressController extends GetxController {
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final deliveryInstructionsController = TextEditingController();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool saveAddress = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill with default country
    countryController.text = 'United Kingdom';
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    deliveryInstructionsController.dispose();
    super.onClose();
  }

  // Validation methods
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Basic phone validation - can be enhanced
    final phoneRegex = RegExp(r'^[\+]?[0-9\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a complete address';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State/County is required';
    }
    return null;
  }

  String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }
    // UK postcode validation (basic)
    if (countryController.text.toLowerCase().contains('kingdom') ||
        countryController.text.toLowerCase().contains('uk')) {
      final ukPostcodeRegex = RegExp(
        r'^[A-Z]{1,2}[0-9][A-Z0-9]? [0-9][ABD-HJLNP-UW-Z]{2}$',
        caseSensitive: false,
      );
      if (!ukPostcodeRegex.hasMatch(value.trim().toUpperCase())) {
        return 'Please enter a valid UK postcode (e.g., SW1A 1AA)';
      }
    }
    return null;
  }

  String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country is required';
    }
    return null;
  }

  // Save shipping address
  Future<void> saveShippingAddress() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      EasyLoading.show(status: 'Saving address...');
      debugPrint('ShippingAddressController: Saving shipping address');
      debugPrint('ShippingAddressController: URL: ${Urls.updateProfile}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ShippingAddressController: Authorization Token: Bearer $token');

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Urls.updateProfile),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['full_name'] = fullNameController.text.trim();
      debugPrint('ShippingAddressController: full_name = ${fullNameController.text.trim()}');

      request.fields['phone'] = phoneController.text.trim();
      debugPrint('ShippingAddressController: phone = ${phoneController.text.trim()}');

      request.fields['country_or_region'] = countryController.text.trim();
      debugPrint('ShippingAddressController: country_or_region = ${countryController.text.trim()}');

      request.fields['address_line_i'] = addressLine1Controller.text.trim();
      debugPrint('ShippingAddressController: address_line_i = ${addressLine1Controller.text.trim()}');

      request.fields['address_line_ii'] = addressLine2Controller.text.trim();
      debugPrint('ShippingAddressController: address_line_ii = ${addressLine2Controller.text.trim()}');

      request.fields['suburb'] = deliveryInstructionsController.text.trim();
      debugPrint('ShippingAddressController: suburb = ${deliveryInstructionsController.text.trim()}');

      request.fields['city'] = cityController.text.trim();
      debugPrint('ShippingAddressController: city = ${cityController.text.trim()}');

      request.fields['postal_code'] = postalCodeController.text.trim();
      debugPrint('ShippingAddressController: postal_code = ${postalCodeController.text.trim()}');

      request.fields['state'] = stateController.text.trim();
      debugPrint('ShippingAddressController: state = ${stateController.text.trim()}');

      request.fields['delivery_instructions'] = deliveryInstructionsController.text.trim();
      debugPrint('ShippingAddressController: delivery_instructions = ${deliveryInstructionsController.text.trim()}');

      debugPrint(
        'ShippingAddressController: Sending PATCH request with multipart form data...',
      );
      debugPrint('ShippingAddressController: Request fields: ${request.fields}');

      // Send request
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint(
        'ShippingAddressController: PATCH Status Code: ${response.statusCode}',
      );
      debugPrint('ShippingAddressController: PATCH Response Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('ShippingAddressController: Response JSON: $jsonData');

        final shippingAddress = ShippingAddress(
          fullName: fullNameController.text.trim(),
          phone: phoneController.text.trim(),
          addressLine1: addressLine1Controller.text.trim(),
          addressLine2: addressLine2Controller.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          postalCode: postalCodeController.text.trim(),
          country: countryController.text.trim(),
          deliveryInstructions: deliveryInstructionsController.text.trim(),
        );

        // Refresh profile data to get updated address
        try {
          final profileController = Get.find<ProfileController>();
          await profileController.fetchProfileData();
          debugPrint('ShippingAddressController: Profile data refreshed successfully');
        } catch (e) {
          debugPrint('ShippingAddressController: Error refreshing profile: $e');
        }

        EasyLoading.showSuccess('Shipping address saved successfully!');
        debugPrint('ShippingAddressController: Address saved successfully');

        // Navigate back to checkout with the address
        Get.back(result: shippingAddress);
      } else {
        String errorMsg = 'Failed to save address';
        try {
          final errorJson = jsonDecode(response.body);
          errorMsg = errorJson['message'] ?? errorMsg;
          debugPrint('ShippingAddressController: Error message from server: $errorMsg');
        } catch (_) {
          debugPrint('ShippingAddressController: Could not parse error response');
        }
        EasyLoading.showError(errorMsg);
        debugPrint('ShippingAddressController: Failed to save address: $errorMsg');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(
        'ShippingAddressController: Exception occurred while saving address',
      );
      debugPrint('ShippingAddressController: Error: $e');
      debugPrint('ShippingAddressController: Error type: ${e.runtimeType}');
      EasyLoading.showError('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    fullNameController.clear();
    phoneController.clear();
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    cityController.clear();
    stateController.clear();
    postalCodeController.clear();
    deliveryInstructionsController.clear();
    // Keep country as default
    countryController.text = 'United Kingdom';
    saveAddress.value = true;
  }

  // Load saved address (if any)
  void loadSavedAddress() {
    // TODO: Load from local storage
    // For demo purposes, load sample data
    fullNameController.text = 'Alex Morgan';
    phoneController.text = '+44 7123 456789';
    addressLine1Controller.text = '1248 Sunset View Dr';
    addressLine2Controller.text = 'Apt 302';
    cityController.text = 'London';
    stateController.text = 'Greater London';
    postalCodeController.text = 'SW1A 1AA';
    countryController.text = 'United Kingdom';
  }
}
