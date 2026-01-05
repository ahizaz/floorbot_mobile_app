import 'package:floor_bot_mobile/app/core/utils/app_images.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<String> suggestedChips = <String>[].obs;
  final RxList<Product> searchResults = <Product>[].obs;
  final RxList<Product> bestDeals = <Product>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSuggestedChips();
    _loadBestDeals();

    // Listen to text changes
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
      ),
      Product(
        id: '2',
        name: 'Parquet',
        description: '4x4 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.parquet,
        category: 'Wood Floor',
      ),
      Product(
        id: '3',
        name: 'Solid wood',
        description: '5x8 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
      ),
      Product(
        id: '4',
        name: 'Parquet',
        description: '4x4 Sqr. m.',
        price: 37.00,
        imageAsset: AppImages.parquet2,
        category: 'Wood Floor',
      ),
    ];
  }

  void _performSearch(String query) {
    isSearching.value = true;

    // Filter products based on search query
    searchResults.value = bestDeals.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void onChipTap(String chipText) {
    searchTextController.text = chipText;
    searchQuery.value = chipText;
    _performSearch(chipText);
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  void onProductTap(String productId) {
    // Find the product and navigate to details
    final allProducts = isSearching.value ? searchResults : bestDeals;
    final product = allProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => bestDeals.first,
    );

    Get.to(
      () => ProductsDetails(product: product),
      transition: Transition.cupertino,
    );
  }

  void onAddToCart(Product product) {
    // TODO: Add to cart logic
    Get.snackbar(
      'Cart',
      '${product.name} added to cart!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
