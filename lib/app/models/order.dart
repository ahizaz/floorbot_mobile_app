class Order {
  final String id;
  final String productId;
  final String productName;
  final String imageAsset;
  final String size;
  final double unitPrice;
  final int quantity;
  final double deliveryFee;
  final double tax;
  final OrderStatus status;
  final String paymentMethod;
  final String cardNumber;
  final String cardExpiry;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.productId,
    required this.productName,
    required this.imageAsset,
    required this.size,
    required this.unitPrice,
    required this.quantity,
    required this.deliveryFee,
    required this.tax,
    required this.status,
    required this.paymentMethod,
    required this.cardNumber,
    required this.cardExpiry,
    required this.orderDate,
  });

  double get subtotal => unitPrice * quantity;

  double get total => subtotal + deliveryFee + tax;

  String get pricePerUnit => '\$${unitPrice.toStringAsFixed(2)}/box';

  double get statusProgress {
    switch (status) {
      case OrderStatus.placed:
        return 0.25;
      case OrderStatus.processing:
        return 0.5;
      case OrderStatus.inTransit:
        return 0.75;
      case OrderStatus.delivered:
        return 1.0;
      case OrderStatus.cancelled:
        return 0.0;
    }
  }

  String get statusText {
    switch (status) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.inTransit:
        return 'In transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isInProgress =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;

  Order copyWith({
    String? id,
    String? productId,
    String? productName,
    String? imageAsset,
    String? size,
    double? unitPrice,
    int? quantity,
    double? deliveryFee,
    double? tax,
    OrderStatus? status,
    String? paymentMethod,
    String? cardNumber,
    String? cardExpiry,
    DateTime? orderDate,
  }) {
    return Order(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageAsset: imageAsset ?? this.imageAsset,
      size: size ?? this.size,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardNumber: cardNumber ?? this.cardNumber,
      cardExpiry: cardExpiry ?? this.cardExpiry,
      orderDate: orderDate ?? this.orderDate,
    );
  }

  // API response থেকে Order object create করার জন্য
  factory Order.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    
    // API থেকে status string কে OrderStatus enum এ convert করো
    OrderStatus orderStatus;
    final statusString = json['status']?.toString().toLowerCase() ?? 'placed';
    
    switch (statusString) {
      case 'placed':
        orderStatus = OrderStatus.placed;
        break;
      case 'processing':
        orderStatus = OrderStatus.processing;
        break;
      case 'in_transit':
      case 'in transit':
        orderStatus = OrderStatus.inTransit;
        break;
      case 'delivered':
        orderStatus = OrderStatus.delivered;
        break;
      case 'cancelled':
        orderStatus = OrderStatus.cancelled;
        break;
      default:
        orderStatus = OrderStatus.placed;
    }
    
    return Order(
      id: '#${json['id']}',
      productId: product['id'].toString(),
      productName: product['product_title'] ?? 'Unknown Product',
      imageAsset: product['primary_image'] ?? '',
      size: '${product['length'] ?? '0'}x${product['width'] ?? '0'} (${product['thickness'] ?? '0'}mm)',
      unitPrice: double.tryParse(product['sale_price']?.toString() ?? '0') ?? 0.0,
      quantity: json['quantity'] ?? 1,
      deliveryFee: double.tryParse(json['delivery_fee']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax_fee']?.toString() ?? '0') ?? 0.0,
      status: orderStatus,
      paymentMethod: 'Credit Card',
      cardNumber: '****',
      cardExpiry: '',
      orderDate: DateTime.now(),
    );
  }
}

enum OrderStatus { placed, processing, inTransit, delivered, cancelled }