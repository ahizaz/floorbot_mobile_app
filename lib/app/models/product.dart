import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price; // Price in GBP (base currency)
  final String? imageAsset;
  final String? imageUrl;
  final String category;
  final ProductCalculatorConfig calculatorConfig;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageAsset,
    this.imageUrl,
    required this.category,
    ProductCalculatorConfig? calculatorConfig,
  }) : calculatorConfig =
           calculatorConfig ?? ProductCalculatorConfig.disabled();

  // Factory constructor to create Product from API JSON response
  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse prices
    final salePrice = double.tryParse(json['sale_price']?.toString() ?? '0') ?? 0.0;
    final regularPrice = double.tryParse(json['regular_price']?.toString() ?? '0') ?? 0.0;
    
    // Use sale price if available and not 0, otherwise use regular price
    final price = (salePrice > 0) ? salePrice : regularPrice;
    
    // Get item description from API
    final description = json['item_description']?.toString() ?? 'No description available';
    
    return Product(
      id: json['id'].toString(),
      name: json['product_title'] ?? 'Unnamed Product',
      description: description,
      price: price,
      imageUrl: json['primary_image'],
      category: json['main_category']?.toString() ?? 'General',
      calculatorConfig: ProductCalculatorConfig.disabled(),
    );
  }
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
