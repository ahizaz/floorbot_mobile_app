class CartItem {
  final String id;
  final String productId;
  final String name;
  final String? imageAsset;
  final String? imageUrl;
  final double price;
  final String size;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    this.imageAsset,
    this.imageUrl,
    required this.price,
    required this.size,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageAsset,
    String? imageUrl,
    double? price,
    String? size,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'imageAsset': imageAsset,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'quantity': quantity,
      'addedAt': addedAt.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      name: json['name'] as String,
      imageAsset: json['imageAsset'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num).toDouble(),
      size: json['size'] as String,
      quantity: json['quantity'] as int,
      addedAt: DateTime.fromMillisecondsSinceEpoch(json['addedAt'] as int),
    );
  }

  // Check if item has expired (24 hours)
  bool get isExpired {
    final now = DateTime.now();
    final difference = now.difference(addedAt);
    return difference.inHours >= 24;
  }
}
