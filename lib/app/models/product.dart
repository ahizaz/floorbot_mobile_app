class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageAsset;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
  });
}

class Category {
  final String id;
  final String name;
  final String imageAsset;

  Category({required this.id, required this.name, required this.imageAsset});
}
