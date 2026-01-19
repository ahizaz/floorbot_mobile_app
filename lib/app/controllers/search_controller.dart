import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/app_images.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<String> suggestedChips = <String>[].obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final RxList<Product> bestDeals = <Product>[].obs;
  final RxList<Product> allProducts = <Product>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoading = false.obs;

  // Get currency controller
  CurrencyController get currencyController => Get.find<CurrencyController>();

  @override
  void onInit() {
    super.onInit();
    _loadSuggestedChips();
    _loadAllProducts();
    _loadBestDeals();

    // Listen to text changes for real-time search
    searchTextController.addListener(() {
      searchQuery.value = searchTextController.text;
      if (searchTextController.text.isNotEmpty) {
        _performSearch(searchTextController.text);
      } else {
        searchResults.clear();
        isSearching.value = false;
      }
    });
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void _loadSuggestedChips() {
    suggestedChips.value = [
      'Carpets',
      'Vinyl',
      'Laminate',
      'Wood flooring',
      'Tiles',
      'Ceramic',
      'Parquet',
      'Solid wood',
    ];
  }

  void _loadAllProducts() {
    // Comprehensive product catalog for search
    allProducts.value = [
      // Carpets
      Product(
        id: 'carpet_1',
        name: 'Luxury Carpet',
        description: '6x9 Sqr. m.',
        price: 45.00,
        imageAsset: AppImages.carpets,
        category: 'Carpets',
        calculatorConfig: ProductCalculatorConfig.carpet(),
      ),
      Product(
        id: 'carpet_2',
        name: 'Premium Carpet',
        description: '8x10 Sqr. m.',
        price: 52.00,
        imageAsset: AppImages.carpets,
        category: 'Carpets',
        calculatorConfig: ProductCalculatorConfig.carpet(),
      ),

      // Vinyl
      Product(
        id: 'vinyl_1',
        name: 'Vinyl Flooring',
        description: '5x7 Sqr. m.',
        price: 35.00,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.vinyl(),
      ),
      Product(
        id: 'vinyl_2',
        name: 'Premium Vinyl',
        description: '6x8 Sqr. m.',
        price: 42.00,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.vinyl(),
      ),

      // Laminate
      Product(
        id: 'laminate_1',
        name: 'Laminate Flooring',
        description: '5x6 Sqr. m.',
        price: 38.00,
        imageAsset: AppImages.laminate,
        category: 'Laminate',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.5),
      ),
      Product(
        id: 'laminate_2',
        name: 'Oak Laminate',
        description: '7x9 Sqr. m.',
        price: 44.00,
        imageAsset: AppImages.laminate,
        category: 'Laminate',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 3.0),
      ),

      // Wood Floor
      Product(
        id: 'wood_1',
        name: 'Solid Wood',
        description: '5x8 Sqr. m.',
        price: 65.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.0),
      ),
      Product(
        id: 'wood_2',
        name: 'Parquet',
        description: '4x4 Sqr. m.',
        price: 55.00,
        imageAsset: AppImages.parquet,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 1.8),
      ),
      Product(
        id: 'wood_3',
        name: 'Premium Parquet',
        description: '6x6 Sqr. m.',
        price: 72.00,
        imageAsset: AppImages.parquet2,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.2),
      ),

      // Ceramic
      Product(
        id: 'ceramic_1',
        name: 'Ceramic Tiles',
        description: '4x6 Sqr. m.',
        price: 28.00,
        imageAsset: AppImages.ceramic,
        category: 'Ceramic',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 1.5),
      ),
      Product(
        id: 'ceramic_2',
        name: 'Designer Ceramic',
        description: '5x7 Sqr. m.',
        price: 35.00,
        imageAsset: AppImages.ceramic,
        category: 'Ceramic',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.0),
      ),

      // Tiles
      Product(
        id: 'tiles_1',
        name: 'Beige Patterned Tiles',
        description: '4x7 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.beige,
        category: 'Tiles',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 1.8),
      ),
      Product(
        id: 'tiles_2',
        name: 'Modern Tiles',
        description: '6x8 Sqr. m.',
        price: 42.00,
        imageAsset: AppImages.beige,
        category: 'Tiles',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.4),
      ),
    ];
  }

  void _loadBestDeals() {
    bestDeals.value = [
      Product(
        id: '1',
        name: 'Beige Patterned Tiles',
        description: '4x7 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.beige,
        category: 'Tiles',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 1.8),
      ),
      Product(
        id: '2',
        name: 'Parquet',
        description: '4x4 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.parquet,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 1.8),
      ),
      Product(
        id: '3',
        name: 'Solid wood',
        description: '5x8 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.0),
      ),
      Product(
        id: '4',
        name: 'Parquet',
        description: '4x4 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.parquet2,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 2.2),
      ),
    ];
  }

  void _performSearch(String query) {
    print('Performing search for: $query'); // Debug log
    isSearching.value = true;
    isLoading.value = true;

    // Perform search across all products with better fuzzy matching
    final lowercaseQuery = query.toLowerCase().trim();

    print('All products count: ${allProducts.length}'); // Debug log

    searchResults.value = allProducts.where((product) {
      final name = product.name.toLowerCase();
      final category = product.category.toLowerCase();
      final description = product.description.toLowerCase();

      // Check for exact matches first
      if (name.contains(lowercaseQuery) ||
          category.contains(lowercaseQuery) ||
          description.contains(lowercaseQuery)) {
        return true;
      }

      // Check for fuzzy matching (individual words)
      final queryWords = lowercaseQuery.split(' ');
      for (String word in queryWords) {
        if (word.isNotEmpty &&
            (name.contains(word) || category.contains(word))) {
          return true;
        }
      }

      return false;
    }).toList();

    print('Search results count: ${searchResults.length}'); // Debug log

    // Sort results by relevance (exact matches first)
    searchResults.sort((a, b) {
      int scoreA = _calculateRelevanceScore(a, lowercaseQuery);
      int scoreB = _calculateRelevanceScore(b, lowercaseQuery);
      return scoreB.compareTo(scoreA); // Higher scores first
    });

    isLoading.value = false;
  }

  int _calculateRelevanceScore(Product product, String query) {
    int score = 0;
    final name = product.name.toLowerCase();
    final category = product.category.toLowerCase();

    // Exact name match gets highest score
    if (name == query)
      score += 100;
    else if (name.startsWith(query))
      score += 80;
    else if (name.contains(query))
      score += 60;

    // Category matches
    if (category == query)
      score += 70;
    else if (category.startsWith(query))
      score += 50;
    else if (category.contains(query))
      score += 30;

    // Word matches
    final queryWords = query.split(' ');
    for (String word in queryWords) {
      if (word.isNotEmpty) {
        if (name.contains(word)) score += 20;
        if (category.contains(word)) score += 15;
      }
    }

    return score;
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
    isLoading.value = false;
  }

  void onChipTap(String chipText) {
    searchTextController.text = chipText;
    searchQuery.value = chipText;
    _performSearch(chipText);
  }

  // Method to search by category
  void searchByCategory(String category) {
    clearSearch();
    onChipTap(category);
  }

  void onProductTap(String productId) {
    // Find the product from all available products
    Product? product;

    if (isSearching.value) {
      product = searchResults.firstWhereOrNull((p) => p.id == productId);
    }

    // If not found in search results, check all products
    product ??= allProducts.firstWhereOrNull((p) => p.id == productId);

    // Fallback to best deals
    product ??= bestDeals.firstWhereOrNull((p) => p.id == productId);

    if (product != null) {
      Get.to(
        () => ProductsDetails(product: product!),
        transition: Transition.cupertino,
      );
    } else {
      Get.snackbar(
        'Error',
        'Product not found',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onAddToCart(Product product) {
    // TODO: Add to cart logic
    Get.snackbar(
      'Cart',
      '${product.name} added to cart!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Format price for display
  String formatProductPrice(Product product) {
    return '${currencyController.formatPrice(product.price)}/box';
  }
}
