import 'dart:convert';
import 'dart:io';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final Rx<ProfileData?> profileData = Rx<ProfileData?>(null);
  final RxBool isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  String? get profileImageUrl {
    if (profileData.value?.image == null) return null;
    final image = profileData.value!.image!;
    if (image.startsWith('http')) return image;
    final baseUrlWithoutApi = Urls.baseUrl.replaceAll('/api/v1', '');
    return '$baseUrlWithoutApi$image';
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  // GET Profile Data
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      debugPrint('ProfileController: Fetching profile data from ${Urls.updateProfile}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ProfileController: Token: $token');

      final response = await http.get(
        Uri.parse(Urls.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('ProfileController: GET Status Code: ${response.statusCode}');
      debugPrint('ProfileController: GET Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final profileModel = ProfileModel.fromJson(jsonData);
        profileData.value = profileModel.profileData;
        debugPrint('ProfileController: Profile data loaded successfully');
        debugPrint('ProfileController: Image URL: ${profileData.value?.image}');
      } else {
        debugPrint('ProfileController: Failed to load profile data');
        EasyLoading.showError('Failed to load profile');
      }
    } catch (e) {
      debugPrint('ProfileController: Error fetching profile: $e');
      EasyLoading.showError('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile Image
  Future<void> updateProfileImage() async {
    try {
      // Pick image from gallery
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        debugPrint('ProfileController: No image selected');
        return;
      }

      EasyLoading.show(status: 'Uploading image...');
      debugPrint('ProfileController: Image selected: ${pickedFile.path}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ProfileController: Token: $token');

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Urls.updateProfile),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add image file
      final file = File(pickedFile.path);
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: pickedFile.name,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      debugPrint('ProfileController: Sending PATCH request to ${Urls.updateProfile}');
      debugPrint('ProfileController: File name: ${pickedFile.name}');
      debugPrint('ProfileController: File size: $length bytes');

      // Send request
      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('ProfileController: PATCH Status Code: ${response.statusCode}');
      debugPrint('ProfileController: PATCH Response Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final profileModel = ProfileModel.fromJson(jsonData);
        profileData.value = profileModel.profileData;
        
        EasyLoading.showSuccess('Profile image updated!');
        debugPrint('ProfileController: Image updated successfully');
        debugPrint('ProfileController: New image URL: ${profileData.value?.image}');
      } else {
        String errorMsg = 'Failed to update image';
        try {
          final errorJson = jsonDecode(response.body);
          errorMsg = errorJson['message'] ?? errorMsg;
        } catch (_) {}
        EasyLoading.showError(errorMsg);
        debugPrint('ProfileController: Failed to update image: $errorMsg');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('ProfileController: Error updating image: $e');
      EasyLoading.showError('Error: $e');
    }
  }

  // Show image picker options
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                updateProfileImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  // Update Profile Data (excluding image)
  Future<void> updateProfileData({
    required String fullName,
    String? phone,
    String? countryOrRegion,
    String? addressLineI,
    String? addressLineIi,
    String? suburb,
    String? city,
    String? postalCode,
    String? state,
  }) async {
    try {
      EasyLoading.show(status: 'Updating profile...');
      debugPrint('ProfileController: Updating profile data');
      debugPrint('ProfileController: URL: ${Urls.updateProfile}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ProfileController: Authorization Token: Bearer $token');

      // Create multipart request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Urls.updateProfile),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['full_name'] = fullName;
      debugPrint('ProfileController: full_name = $fullName');
      
      if (phone != null && phone.isNotEmpty) {
        request.fields['phone'] = phone;
        debugPrint('ProfileController: phone = $phone');
      }
      
      if (countryOrRegion != null && countryOrRegion.isNotEmpty) {
        request.fields['country_or_region'] = countryOrRegion;
        debugPrint('ProfileController: country_or_region = $countryOrRegion');
      }
      
      if (addressLineI != null && addressLineI.isNotEmpty) {
        request.fields['address_line_i'] = addressLineI;
        debugPrint('ProfileController: address_line_i = $addressLineI');
      }
      
      if (addressLineIi != null && addressLineIi.isNotEmpty) {
        request.fields['address_line_ii'] = addressLineIi;
        debugPrint('ProfileController: address_line_ii = $addressLineIi');
      }
      
      if (suburb != null && suburb.isNotEmpty) {
        request.fields['suburb'] = suburb;
        debugPrint('ProfileController: suburb = $suburb');
      }
      
      if (city != null && city.isNotEmpty) {
        request.fields['city'] = city;
        debugPrint('ProfileController: city = $city');
      }
      
      if (postalCode != null && postalCode.isNotEmpty) {
        request.fields['postal_code'] = postalCode;
        debugPrint('ProfileController: postal_code = $postalCode');
      }
      
      if (state != null && state.isNotEmpty) {
        request.fields['state'] = state;
        debugPrint('ProfileController: state = $state');
      }

      debugPrint('ProfileController: Sending PATCH request with multipart form data...');
      debugPrint('ProfileController: Request fields: ${request.fields}');

      // Send request
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('ProfileController: PATCH Status Code: ${response.statusCode}');
      debugPrint('ProfileController: PATCH Response Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('ProfileController: Response JSON: $jsonData');
        
        final profileModel = ProfileModel.fromJson(jsonData);
        profileData.value = profileModel.profileData;
        
        EasyLoading.showSuccess('Profile updated successfully!');
        debugPrint('ProfileController: Profile updated successfully');
        debugPrint('ProfileController: Updated profile - Name: ${profileData.value?.fullName}, Email: ${profileData.value?.email}');
      } else {
        String errorMsg = 'Failed to update profile';
        try {
          final errorJson = jsonDecode(response.body);
          errorMsg = errorJson['message'] ?? errorMsg;
          debugPrint('ProfileController: Error message from server: $errorMsg');
        } catch (_) {
          debugPrint('ProfileController: Could not parse error response');
        }
        EasyLoading.showError(errorMsg);
        debugPrint('ProfileController: Failed to update profile: $errorMsg');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('ProfileController: Exception occurred while updating profile');
      debugPrint('ProfileController: Error: $e');
      debugPrint('ProfileController: Error type: ${e.runtimeType}');
      EasyLoading.showError('Error: $e');
    }
  }
}