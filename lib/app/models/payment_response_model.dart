class PaymentResponseModel {
  final bool success;
  final PaymentData payment;
  final StripeData stripe;

  PaymentResponseModel({
    required this.success,
    required this.payment,
    required this.stripe,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      success: json['success'] ?? false,
      payment: PaymentData.fromJson(json['payment']),
      stripe: StripeData.fromJson(json['stripe']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'payment': payment.toJson(),
      'stripe': stripe.toJson(),
    };
  }
}

class PaymentData {
  final String paymentIntentId;
  final String clientSecret;
  final double amount;
  final String currency;
  final String productName;
  final int qty;

  PaymentData({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.productName,
    required this.qty,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      paymentIntentId: json['payment_intent_id'] ?? '',
      clientSecret: json['client_secret'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'usd',
      productName: json['product_name'] ?? '',
      qty: json['qty'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_intent_id': paymentIntentId,
      'client_secret': clientSecret,
      'amount': amount,
      'currency': currency,
      'product_name': productName,
      'qty': qty,
    };
  }
}

class StripeData {
  final String publishableKey;

  StripeData({required this.publishableKey});

  factory StripeData.fromJson(Map<String, dynamic> json) {
    return StripeData(publishableKey: json['publishable_key'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'publishable_key': publishableKey};
  }
}
