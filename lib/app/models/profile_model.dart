class ProfileModel {
  final bool success;
  final String message;
  final ProfileData profileData;

  ProfileModel({
    required this.success,
    required this.message,
    required this.profileData,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'profile_data' and 'errors' field (API returns data in 'errors' on PATCH)
    Map<String, dynamic> data = {};
    if (json['profile_data'] != null) {
      data = json['profile_data'];
    } else if (json['errors'] != null) {
      data = json['errors'];
    }
    
    return ProfileModel(
      success: json['successs'] ?? json['success'] ?? false,
      message: json['message'] ?? '',
      profileData: ProfileData.fromJson(data),
    );
  }
}
class ProfileData{
  final String fullName;
  final String email;
  final String? phone;
  final String? image;
  final String? latitude;
  final String? longitude;
  final String? countryOrRegion;
  final String? addressLineI;
  final String? addressLineIi;
  final String? suburb;
  final String? city;
  final String? postalCode;
  final String? state;
  ProfileData({
       required this.fullName,
    required this.email,
    this.phone,
    this.image,
    this.latitude,
    this.longitude,
    this.countryOrRegion,
    this.addressLineI,
    this.addressLineIi,
    this.suburb,
    this.city,
    this.postalCode,
    this.state
  });
  factory ProfileData.fromJson(Map<String,dynamic>json){
    return ProfileData(
    fullName: json['full_name'] ?? '', 
    email: json['email'] ?? '',
    phone: json['phone'],
    image: json['image'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    countryOrRegion: json['country_or_region'],
    addressLineI: json['address_line_i'],
    addressLineIi: json['address_line_ii'],
    suburb: json['suburb'],
    city: json['city'],
    postalCode: json['postal_code'],
    state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'country_or_region': countryOrRegion,
      'address_line_i': addressLineI,
      'address_line_ii': addressLineIi,
      'suburb': suburb,
      'city': city,
      'postal_code': postalCode,
      'state': state,
    };
  }
}