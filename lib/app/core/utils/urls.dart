class Urls{
  static const String baseUrl = "http://10.10.12.15:8089/api/v1";
  static const String signUp ="$baseUrl/auth/signup/";
  static String signUpOtp(String email) => "$baseUrl/auth/verify/$email/";
  static String signIn = "$baseUrl/auth/login/";
  

}