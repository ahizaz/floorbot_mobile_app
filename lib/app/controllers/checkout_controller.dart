import 'dart:convert';
import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/controllers/order_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/payment_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutController extends GetxController {
  final Rx<PaymentResponseModel?> paymentResponse = Rx<PaymentResponseModel?>(
    null,
  );
  final RxBool isLoading = false.obs;

  // Create order and get payment intent
  Future<void> createOrder({
    required String productId,
    required int qty,
    required String countryOrRegion,
    required String addressLineI,
    String? addressLineIi,
    required String suburb,
    required String city,
    required String postalCode,
    required String state,
  }) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Creating order...');

      debugPrint('CheckoutController: Creating order at ${Urls.confirmorders}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('CheckoutController: Token: $token');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'product_id': int.parse(productId),
        'qty': qty,
        'country_or_region': countryOrRegion,
        'address_line_i': addressLineI,
        'suburb': suburb,
        'city': city,
        'postal_code': postalCode,
        'state': state,
      };

      // Add optional fields
      if (addressLineIi != null && addressLineIi.isNotEmpty) {
        requestBody['address_line_ii'] = addressLineIi;
      }

      debugPrint(
        'CheckoutController: Request Body: ${jsonEncode(requestBody)}',
      );

      final response = await http
          .post(
            Uri.parse(Urls.confirmorders),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('CheckoutController: Status Code: ${response.statusCode}');
      debugPrint('CheckoutController: Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        paymentResponse.value = PaymentResponseModel.fromJson(jsonData);

        debugPrint('CheckoutController: Order created successfully');
        debugPrint(
          'CheckoutController: Payment Intent ID: ${paymentResponse.value?.payment.paymentIntentId}',
        );
        debugPrint(
          'CheckoutController: Client Secret: ${paymentResponse.value?.payment.clientSecret}',
        );
        debugPrint(
          'CheckoutController: Publishable Key: ${paymentResponse.value?.stripe.publishableKey}',
        );

        EasyLoading.dismiss();

        // Initialize Stripe and proceed to payment
        await initializeStripePayment();
      } else {
        debugPrint('CheckoutController: Failed to create order');
        EasyLoading.showError('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('CheckoutController: Error creating order: $e');
      EasyLoading.showError('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Initialize Stripe payment
  Future<void> initializeStripePayment() async {
    try {
      if (paymentResponse.value == null) {
        debugPrint('CheckoutController: No payment response available');
        EasyLoading.showError('Payment data not available');
        return;
      }

      final publishableKey = paymentResponse.value!.stripe.publishableKey;
      final clientSecret = paymentResponse.value!.payment.clientSecret;

      debugPrint(
        'CheckoutController: Initializing Stripe with publishable key: $publishableKey',
      );

      // Set Stripe publishable key
      Stripe.publishableKey = publishableKey;

      EasyLoading.show(status: 'Initializing payment...');

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Floor Bot',
          style: ThemeMode.system,
        ),
      );

      debugPrint('CheckoutController: Payment sheet initialized successfully');
      EasyLoading.dismiss();

      // Present payment sheet
      await presentPaymentSheet();
    } catch (e) {
      debugPrint('CheckoutController: Error initializing payment: $e');
      EasyLoading.showError('Payment initialization failed: $e');
    }
  }

  // Present payment sheet
  Future<void> presentPaymentSheet() async {
    try {
      EasyLoading.show(status: 'Processing payment...');

      await Stripe.instance.presentPaymentSheet();

      debugPrint('CheckoutController: Payment completed successfully');
      EasyLoading.showSuccess('Payment successful!');

      // Clear cart after successful payment
      try {
        final cartController = Get.find<CartController>();
        cartController.clearCart();
        debugPrint('CheckoutController: Cart cleared successfully');
      } catch (e) {
        debugPrint('CheckoutController: Error clearing cart: $e');
      }

      // Automatically fetch orders after successful payment
      try {
        final orderController = Get.find<OrderController>();
        await orderController.fetchOrders();
        debugPrint(
          'CheckoutController: Orders fetched successfully after payment',
        );
      } catch (e) {
        debugPrint('CheckoutController: Error fetching orders: $e');
      }

      // Navigate to success screen or order confirmation
      Get.snackbar(
        'Payment Successful',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // TODO: Navigate to order success screen
      // Get.offAll(() => OrderSuccessScreen());
    } on StripeException catch (e) {
      debugPrint(
        'CheckoutController: Stripe error: ${e.error.localizedMessage}',
      );

      if (e.error.code == FailureCode.Canceled) {
        EasyLoading.showInfo('Payment cancelled');
      } else {
        EasyLoading.showError('Payment failed: ${e.error.localizedMessage}');
      }
    } catch (e) {
      debugPrint('CheckoutController: Error presenting payment sheet: $e');
      EasyLoading.showError('Payment failed: $e');
    }
  }
}
