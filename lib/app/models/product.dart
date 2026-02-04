import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price; // Price in GBP (base currency)
  final String imageAsset;
  final String category;
  final ProductCalculatorConfig calculatorConfig;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    ProductCalculatorConfig? calculatorConfig,
  }) : calculatorConfig =
           calculatorConfig ?? ProductCalculatorConfig.disabled();
}

class Category {
  final String id;
  final String name;
  final String? imageAsset;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    this.imageAsset,
    this.imageUrl,
  });

  // Factory constructor to create Category from API JSON response
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['title'] ?? json['name'] ?? '',
      imageUrl: json['image'],
    );
  }
}
