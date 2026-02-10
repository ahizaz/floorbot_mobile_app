class Urls {
  static const String serverBase = "http://10.10.12.15:8089";
  static const String baseUrl = "$serverBase/api/v1";
  static const String websocketBase = "ws://10.10.12.15:8089/ws/chats/support/";
  static const String signUp = "$baseUrl/auth/signup/";
  static String signUpOtp(String email) => "$baseUrl/auth/verify/$email/";
  static String signIn = "$baseUrl/auth/login/";
  static String forgetPassword = "$baseUrl/auth/forgetpassword/";
  static String forgetPasswordOtp(String email) =>
      "$baseUrl/auth/vefiry_for_forget/$email/";
  static String resetPassword = "$baseUrl/auth/reset_password/";
  static const String catagoriesScreen = "$baseUrl/users/categories/";
  static const String catagories = "$baseUrl/users/categories/";
  static const String newProduct = "$baseUrl/users/products/?search=newest";
  static const String bestDeals = "$baseUrl/users/products/?search=best";
  //static const String search ="$baseUrl/users/products/?search=soft carpet";
  static String searchProducts(String query) =>
      "$baseUrl/users/products/?search=$query";
  static const String updateProfile = "$baseUrl/users/profile-data/";
  static const String confirmorders = "$baseUrl/users/orders/";
  static const String userOrders = "$baseUrl/users/orders/";
  static const String confirmDelivery = "$baseUrl/users/orders/";
  static const String feedBack = "$baseUrl/users/orders/";
  static const String notification = "$baseUrl/chats/notifications/";
  static const String unseenNotification =
      "$baseUrl/chats/unseen-notifications-count/";
  static const String supportmessage = "$baseUrl/chats/supports";
}
