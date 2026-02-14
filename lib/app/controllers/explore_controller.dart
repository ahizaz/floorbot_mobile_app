import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/app_images.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:floor_bot_mobile/app/views/screens/products/best_deals_product_details.dart';
import 'package:floor_bot_mobile/app/views/screens/products/all_products_screen.dart';
import 'package:floor_bot_mobile/app/views/screens/category/category_products_screen.dart';
import 'package:floor_bot_mobile/app/views/screens/cart/my_cart_view.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreController extends GetxController {
  // Observable lists
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Product> newArrivals = <Product>[].obs;
  final RxList<Product> bestDeals = <Product>[].obs;
  final RxBool isLoadingCategories = false.obs;
//New Arrivals pagination
  final RxBool isLoadingMoreNewArrivals =false.obs;
  final RxInt currentNewArrivalsPage = 1.obs;
  final RxInt totalNewArrivalsPages=1.obs;
  final RxBool hasMoreNewArrivals = true.obs;
  final RxString nextNewArrivalsUrl=''.obs;

  //Best Deals pagination
  final RxBool isLoadingMoreBestDeals = false.obs;
  final RxInt currentBestDealsPage = 1.obs;
  final RxInt totalBestDealsPages = 1.obs;
  final RxBool hasMoreBestDeals =true.obs;
  final RxString nextBestDealsUrl=''.obs;


  @override
  void onInit() {
    super.onInit();
    _fetchCategoriesFromAPI();
    _fetchNewArrivalsFromAPI();
    _fetchBestDealsFromAPI();
  }

  // Fetch categories from API
  Future<void> _fetchCategoriesFromAPI() async {
    try {
      isLoadingCategories.value = true;
      EasyLoading.show(status: 'Loading categories...');

      debugPrint(
        'ExploreController: Fetching categories from ${Urls.catagories}',
      );

      // Get bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ExploreController: Token: $token');

      // Make API call with bearer token
      final response = await http
          .get(
            Uri.parse(Urls.catagories),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      debugPrint('ExploreController: Status Code: ${response.statusCode}');
      debugPrint('ExploreController: Response Body: ${response.body}');

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('ExploreController: Parsed JSON: $jsonData');

        if (jsonData['success'] == true && jsonData['categories'] != null) {
          final List<dynamic> categoriesJson = jsonData['categories'];
          debugPrint(
            'ExploreController: Categories count: ${categoriesJson.length}',
          );

          // Map JSON to Category objects
          categories.value = categoriesJson
              .map((json) => Category.fromJson(json))
              .toList();

          debugPrint(
            'ExploreController: Successfully loaded ${categories.length} categories',
          );
          EasyLoading.showSuccess('Categories loaded!');
        } else {
          debugPrint('ExploreController: Invalid response format');
          _loadDefaultCategories();
          EasyLoading.showError('Failed to load categories');
        }
      } else {
        debugPrint(
          'ExploreController: Failed with status ${response.statusCode}',
        );
        _loadDefaultCategories();
        EasyLoading.showError('Failed to fetch categories');
      }
    } catch (e) {
      debugPrint('ExploreController: Error fetching categories: $e');
      EasyLoading.dismiss();
      _loadDefaultCategories();
      EasyLoading.showError('Error: ${e.toString()}');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Fallback to default categories if API fails
  void _loadDefaultCategories() {
    categories.value = [
      Category(id: '1', name: 'Carpets', imageAsset: AppImages.carpets),
      Category(id: '2', name: 'Vinyl', imageAsset: AppImages.vinyl),
      Category(id: '3', name: 'Laminate', imageAsset: AppImages.laminate),
      Category(id: '4', name: 'Wood Floor', imageAsset: AppImages.wood),
    ];
    debugPrint('ExploreController: Loaded default categories');
  }

  // Fetch new arrivals from API
  Future<void> _fetchNewArrivalsFromAPI() async {
    try {
      EasyLoading.show(status: 'Loading products...');

      debugPrint(
        'ExploreController: Fetching new arrivals from ${Urls.newProduct}',
      );

      // Get bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ExploreController: Token: $token');

      // Make API call with bearer token
      final response = await http
          .get(
            Uri.parse(Urls.newProduct),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      debugPrint(
        'ExploreController: New Arrivals Status Code: ${response.statusCode}',
      );
      debugPrint(
        'ExploreController: New Arrivals Response Body: ${response.body}',
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('ExploreController: Parsed JSON: $jsonData');

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> productsJson = jsonData['data'];
          if(jsonData['meta']!=null){
            final meta = jsonData['meta'];
            currentNewArrivalsPage.value = meta['current_page']??1;
            totalNewArrivalsPages.value = meta['total_pages']??1;
            nextNewArrivalsUrl.value = meta['next']??'';
            hasMoreNewArrivals.value= nextNewArrivalsUrl.value.isNotEmpty;


          }

          debugPrint(
            'ExploreController: Products count: ${productsJson.length}',
          );

          // Map JSON to Product objects
          newArrivals.value = productsJson
              .map((json) => Product.fromJson(json))
              .toList();

          debugPrint(
            'ExploreController: Successfully loaded ${newArrivals.length} new arrival products',
          );
          EasyLoading.showSuccess('Products loaded!');
        } else {
          debugPrint('ExploreController: Invalid response format for products');
          _loadDefaultNewArrivals();
          EasyLoading.showError('Failed to load products');
        }
      } else {
        debugPrint(
          'ExploreController: Failed with status ${response.statusCode}',
        );
        _loadDefaultNewArrivals();
        EasyLoading.showError('Failed to fetch products');
      }
    } catch (e) {
      debugPrint('ExploreController: Error fetching new arrivals: $e');
      EasyLoading.dismiss();
      _loadDefaultNewArrivals();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  // Fallback to default new arrivals if API fails
  void _loadDefaultNewArrivals() {
    newArrivals.value = [
      Product(
        id: '1',
        name: 'Solid wood',
        description: '4x7 Sqr. m.',
        price: 39.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 28.0,
        ),
      ),
      Product(
        id: '2',
        name: 'Parquet',
        description: '4x4 Sqr. m.',
        price: 39.00,
        imageAsset: AppImages.parquet,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 16.0,
        ),
      ),
      Product(
        id: '3',
        name: 'Ceramic',
        description: '3x5 Sqr. m.',
        price: 39.00,
        imageAsset: AppImages.ceramic,
        category: 'Laminate',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 15.0,
        ),
      ),
      Product(
        id: '4',
        name: 'Beige Wood',
        description: '5x7 Sqr. m.',
        price: 45.00,
        imageAsset: AppImages.beige,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 35.0,
        ),
      ),
    ];
    debugPrint('ExploreController: Loaded default new arrivals');
  }

  // Fetch best deals from API
  Future<void> _fetchBestDealsFromAPI() async {
    try {
      EasyLoading.show(status: 'Loading best deals...');

      debugPrint(
        'ExploreController: Fetching best deals from ${Urls.bestDeals}',
      );

      // Get bearer token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      debugPrint('ExploreController: Token: $token');

      // Make API call with bearer token
      final response = await http
          .get(
            Uri.parse(Urls.bestDeals),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      debugPrint(
        'ExploreController: Best Deals Status Code: ${response.statusCode}',
      );
      debugPrint(
        'ExploreController: Best Deals Response Body: ${response.body}',
      );

      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        debugPrint('ExploreController: Parsed JSON: $jsonData');

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> productsJson = jsonData['data'];
          debugPrint(
            'ExploreController: Best deals count: ${productsJson.length}',
          );

          // Map JSON to Product objects
          bestDeals.value = productsJson
              .map((json) => Product.fromJson(json))
              .toList();

          debugPrint(
            'ExploreController: Successfully loaded ${bestDeals.length} best deals products',
          );
          EasyLoading.showSuccess('Best deals loaded!');
        } else {
          debugPrint(
            'ExploreController: Invalid response format for best deals',
          );
          _loadDefaultBestDeals();
          EasyLoading.showError('Failed to load best deals');
        }
      } else {
        debugPrint(
          'ExploreController: Failed with status ${response.statusCode}',
        );
        _loadDefaultBestDeals();
        EasyLoading.showError('Failed to fetch best deals');
      }
    } catch (e) {
      debugPrint('ExploreController: Error fetching best deals: $e');
      EasyLoading.dismiss();
      _loadDefaultBestDeals();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  // Fallback to default best deals if API fails
  void _loadDefaultBestDeals() {
    bestDeals.value = [
      Product(
        id: '5',
        name: 'Oak wood',
        description: '5x8 Sqr. m.',
        price: 39.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 40.0, // 5x8 coverage per box
        ),
      ),
      Product(
        id: '6',
        name: 'Parquet Premium',
        description: '3x3 Sqr. m.',
        price: 24.99,
        imageAsset: AppImages.parquet2,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 9.0, // 3x3 coverage per box
        ),
      ),
      Product(
        id: '7',
        name: 'Luxury vinyl',
        description: '4x6 Sqr. m.',
        price: 29.99,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.vinyl(),
      ),
      Product(
        id: '8',
        name: 'Premium Carpet',
        description: 'Available in 4m/5m widths',
        price: 35.99,
        imageAsset: AppImages.carpets,
        category: 'Carpet',
        calculatorConfig: ProductCalculatorConfig.carpet(),
      ),
    ];
    debugPrint('ExploreController: Loaded default best deals');
  }

  // Actions
  void onCategoryTap(String categoryId) {
    // Map category ID to category name
    String categoryName;
    switch (categoryId) {
      case '1':
        categoryName = 'Carpets';
        break;
      case '2':
        categoryName = 'Vinyl';
        break;
      case '3':
        categoryName = 'Laminate';
        break;
      case '4':
        categoryName = 'Wood Floor';
        break;
      default:
        categoryName = 'Products';
    }

    // Navigate to category products screen
    Get.to(
      () => CategoryProductsScreen(
        categoryName: categoryName,
        categoryId: categoryId,
      ),
      transition: Transition.cupertino,
    );
  }

  void onProductTap(String productId, {bool isBestDeal = false}) {
    // Find the product and navigate to details
    final product = [
      ...newArrivals,
      ...bestDeals,
    ].firstWhere((p) => p.id == productId, orElse: () => newArrivals.first);

    // Navigate to different details pages based on product type
    if (isBestDeal) {
      Get.to(
        () => BestDealsProductDetails(product: product),
        transition: Transition.cupertino,
      );
    } else {
      Get.to(
        () => ProductsDetails(product: product),
        transition: Transition.cupertino,
      );
    }
  }

  void onAddToCart(Product product) {
    // Get or create cart controller
    CartController cartController;
    try {
      cartController = Get.find<CartController>();
    } catch (e) {
      cartController = Get.put(CartController());
    }

    // Add product to cart (will save to SharedPreferences automatically)
    cartController.addToCart(product, quantity: 1);

    // Navigate to My Cart view
    Get.to(() => const MyCartView(), transition: Transition.cupertino);
  }

  void onShowAllNewArrivals() {
    Get.to(
      () => AllProductsScreen(
        title: 'New Arrivals',
        products: List<Product>.from(newArrivals),
        onProductTap: onProductTap,
        onAddToCart: onAddToCart,
        formatPrice: formatProductPrice,
        isBestDeal: false,
      ),
      transition: Transition.cupertino,
    );
  }

  void onShowAllBestDeals() {
    Get.to(
      () => AllProductsScreen(
        title: 'Best Deals',
        products: List<Product>.from(bestDeals),
        onProductTap: onProductTap,
        onAddToCart: onAddToCart,
        formatPrice: formatProductPrice,
        isBestDeal: true,
      ),
      transition: Transition.cupertino,
    );
  }

  // Format price for display
  String formatProductPrice(Product product) {
    return '${Get.find<CurrencyController>().formatPrice(product.price)}/box';
  }
  // Load more new arrivals for pagination
Future<void> loadMoreNewArrivals() async {
  if (isLoadingMoreNewArrivals.value || !hasMoreNewArrivals.value) return;

  try {
    isLoadingMoreNewArrivals.value = true;
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access') ?? '';
    
    // Use next URL from response or construct URL with next page
    String url = nextNewArrivalsUrl.value.isNotEmpty 
        ? nextNewArrivalsUrl.value 
        : Urls.newProductWithPage(currentNewArrivalsPage.value + 1);
    
    debugPrint('ExploreController: Loading more new arrivals from $url');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 30));
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        final List<dynamic> productsJson = jsonData['data'];
        
        // Update meta info
        if (jsonData['meta'] != null) {
          final meta = jsonData['meta'];
          currentNewArrivalsPage.value = meta['current_page'] ?? currentNewArrivalsPage.value;
          totalNewArrivalsPages.value = meta['total_pages'] ?? totalNewArrivalsPages.value;
          nextNewArrivalsUrl.value = meta['next'] ?? '';
          hasMoreNewArrivals.value = nextNewArrivalsUrl.value.isNotEmpty;
        }
        
        // Add new products to existing list
        final newProducts = productsJson
            .map((json) => Product.fromJson(json))
            .toList();
        newArrivals.addAll(newProducts);
        
        debugPrint('ExploreController: Loaded ${newProducts.length} more products. Total: ${newArrivals.length}');
      }
    }
  } catch (e) {
    debugPrint('ExploreController: Error loading more new arrivals: $e');
  } finally {
    isLoadingMoreNewArrivals.value = false;
  }
}

// Same for best deals
Future<void> loadMoreBestDeals() async {
  if (isLoadingMoreBestDeals.value || !hasMoreBestDeals.value) return;

  try {
    isLoadingMoreBestDeals.value = true;
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access') ?? '';
    
    String url = nextBestDealsUrl.value.isNotEmpty 
        ? nextBestDealsUrl.value 
        : '${Urls.bestDeals}&page=${currentBestDealsPage.value + 1}';
    
    debugPrint('ExploreController: Loading more best deals from $url');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 30));
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        final List<dynamic> productsJson = jsonData['data'];
        
        if (jsonData['meta'] != null) {
          final meta = jsonData['meta'];
          currentBestDealsPage.value = meta['current_page'] ?? currentBestDealsPage.value;
          totalBestDealsPages.value = meta['total_pages'] ?? totalBestDealsPages.value;
          nextBestDealsUrl.value = meta['next'] ?? '';
          hasMoreBestDeals.value = nextBestDealsUrl.value.isNotEmpty;
        }
        
        final newProducts = productsJson
            .map((json) => Product.fromJson(json))
            .toList();
        bestDeals.addAll(newProducts);
        
        debugPrint('ExploreController: Loaded ${newProducts.length} more best deals. Total: ${bestDeals.length}');
      }
    }
  } catch (e) {
    debugPrint('ExploreController: Error loading more best deals: $e');
  } finally {
    isLoadingMoreBestDeals.value = false;
  }
}
}
