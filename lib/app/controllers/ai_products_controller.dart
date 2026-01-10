import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:get/get.dart';

class AiProductsController extends GetxController {
  // Observables
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;

  // Category for the screen
  final String category;

  AiProductsController({required this.category});

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  void _loadProducts() {
    isLoading.value = true;

    // Mock data - Replace with actual API call
    products.value = [
      Product(
        id: '1',
        name: 'Solid wood',
        description: '4x7 Sqr. m.',
        price: 39.00,
        imageAsset: 'assets/images/solid_wood.png',
        category: 'Wood',
      ),
      Product(
        id: '2',
        name: 'Solid wood',
        description: '4x7 Sqr. m.',
        price: 39.00,
        imageAsset: 'assets/images/solid_wood.png',
        category: 'Wood',
      ),
      Product(
        id: '3',
        name: 'Solid wood',
        description: '4x7 Sqr. m.',
        price: 39.00,
        imageAsset: 'assets/images/solid_wood.png',
        category: 'Wood',
      ),
      Product(
        id: '4',
        name: 'Parquet',
        description: '4x7 Sqr. m.',
        price: 45.00,
        imageAsset: 'assets/images/parquet.png',
        category: 'Wood',
      ),
      Product(
        id: '5',
        name: 'Laminate',
        description: '4x7 Sqr. m.',
        price: 35.00,
        imageAsset: 'assets/images/laminent.png',
        category: 'Wood',
      ),
      Product(
        id: '6',
        name: 'Vinyl',
        description: '4x7 Sqr. m.',
        price: 42.00,
        imageAsset: 'assets/images/venyl.png',
        category: 'Vinyl',
      ),
    ];

    filteredProducts.value = products;
    isLoading.value = false;
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void _applyFilters() {
    filteredProducts.value = products.where((product) {
      final matchesSearch =
          searchQuery.value.isEmpty ||
          product.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          product.description.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      final matchesCategory =
          selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void addToCart(Product product) {
    // TODO: Implement add to cart functionality
    Get.snackbar(
      'Added to Cart',
      '${product.name} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  int get totalProductsFound => filteredProducts.length;
}
