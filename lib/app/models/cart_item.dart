class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imageAsset;
  final double price;
  final String size;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageAsset,
    required this.price,
    required this.size,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageAsset,
    double? price,
    String? size,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageAsset: imageAsset ?? this.imageAsset,
      price: price ?? this.price,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }
}
