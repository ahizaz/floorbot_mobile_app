class Urls{
  static const String baseUrl = "http://10.10.12.15:8089/api/v1";
  static const String signUp ="$baseUrl/auth/signup/";
  static String signUpOtp(String email) => "$baseUrl/auth/verify/$email/";
  static String signIn = "$baseUrl/auth/login/";
  static String forgetPassword ="$baseUrl/auth/forgetpassword/";
  static String forgetPasswordOtp(String email) => "$baseUrl/auth/vefiry_for_forget/$email/";
  static String resetPassword = "$baseUrl/auth/reset_password/";
  static const String catagoriesScreen = "$baseUrl/users/categories/";
  static const String catagories = "$baseUrl/users/categories/";
 static const String newProduct ="$baseUrl/users/products/?search=newest";
  



}