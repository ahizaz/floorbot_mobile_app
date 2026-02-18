import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/app_images.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:floor_bot_mobile/app/views/screens/products/best_deals_product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  Timer? _debounce;
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
    _fetchBestDealsFromAPI();

    // Listen to text changes for real-time search
    searchTextController.addListener(() {
      final text = searchTextController.text;
      searchQuery.value = text;
      if (text.isNotEmpty) {
        // debounce rapid input to avoid stale/irrelevant responses
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 400), () {
          _performSearch(text);
        });
      } else {
        _debounce?.cancel();
        searchResults.clear();
        isSearching.value = false;
      }
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
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

  // Fetch best deals from API
  Future<void> _fetchBestDealsFromAPI() async {
    try {
      debugPrint('SearchController: Fetching best deals from ${Urls.bestDeals}');
      
      // Get bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('SearchController: Token: $token');
      
      // Make API call with bearer token
      final response = await http.get(
        Uri.parse(Urls.bestDeals),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      
      debugPrint('SearchController: Best Deals Status Code: ${response.statusCode}');
      debugPrint('SearchController: Best Deals Response Body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('SearchController: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> productsJson = jsonData['data'];
          debugPrint('SearchController: Best deals count: ${productsJson.length}');
          
          // Map JSON to Product objects
          bestDeals.value = productsJson
              .map((json) => Product.fromJson(json))
              .toList();
          
          debugPrint('SearchController: Successfully loaded ${bestDeals.length} best deals products');
        } else {
          debugPrint('SearchController: Invalid response format for best deals');
          _loadDefaultBestDeals();
        }
      } else {
        debugPrint('SearchController: Failed with status ${response.statusCode}');
        _loadDefaultBestDeals();
      }
    } catch (e) {
      debugPrint('SearchController: Error fetching best deals: $e');
      _loadDefaultBestDeals();
    }
  }

  // Fallback to default best deals if API fails
  void _loadDefaultBestDeals() {
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
    debugPrint('SearchController: Loaded default best deals');
  }

  // Fetch search results from API
  Future<void> _fetchSearchResultsFromAPI(String query) async {
    try {
      EasyLoading.show(status: 'Searching...');
      
      debugPrint('SearchController: Searching for "$query" from ${Urls.searchProducts(query)}');
      
      // Get bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('SearchController: Token: $token');
      
      // Make API call with bearer token
      final response = await http.get(
        Uri.parse(Urls.searchProducts(query)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      
      debugPrint('SearchController: Search Status Code: ${response.statusCode}');
      debugPrint('SearchController: Search Response Body: ${response.body}');
      
      EasyLoading.dismiss();
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('SearchController: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> productsJson = jsonData['data'];
          debugPrint('SearchController: Search results count: ${productsJson.length}');
          
          // Map JSON to Product objects
          searchResults.value = productsJson
              .map((json) => Product.fromJson(json))
              .toList();
          
          debugPrint('SearchController: Successfully loaded ${searchResults.length} search results');
          
          if (searchResults.isEmpty) {
            EasyLoading.showInfo('No products found for "$query"');
          } else {
            EasyLoading.showSuccess('Found ${searchResults.length} products');
          }
        } else {
          debugPrint('SearchController: Invalid response format for search');
          searchResults.clear();
          EasyLoading.showError('Failed to load search results');
        }
      } else {
        debugPrint('SearchController: Failed with status ${response.statusCode}');
        searchResults.clear();
        EasyLoading.showError('Search failed');
      }
    } catch (e) {
      debugPrint('SearchController: Error fetching search results: $e');
      EasyLoading.dismiss();
      searchResults.clear();
      EasyLoading.showError('Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _performSearch(String query) {
    debugPrint('SearchController: Performing search for: $query');
    isSearching.value = true;
    isLoading.value = true;

    // Call the API to fetch search results
    _fetchSearchResultsFromAPI(query);
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
    bool isBestDeal = false;

    if (isSearching.value) {
      product = searchResults.firstWhereOrNull((p) => p.id == productId);
    }

    // If not found in search results, check all products
    product ??= allProducts.firstWhereOrNull((p) => p.id == productId);

    // Fallback to best deals
    if (product == null) {
      product = bestDeals.firstWhereOrNull((p) => p.id == productId);
      if (product != null) {
        isBestDeal = true;
      }
    }

    if (product != null) {
      // Navigate to different details pages based on product type
      if (isBestDeal) {
        Get.to(
          () => BestDealsProductDetails(product: product!),
          transition: Transition.cupertino,
        );
      } else {
        Get.to(
          () => ProductsDetails(product: product!),
          transition: Transition.cupertino,
        );
      }
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
