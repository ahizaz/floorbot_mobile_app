import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/app_images.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:get/get.dart';

class CategoryProductsController extends GetxController {
  final String categoryName;
  final String categoryId;

  // Observables
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;

  // Filter options
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100.0.obs;
  final RxString selectedSort =
      'default'.obs; // default, price_low, price_high, name

  CategoryProductsController({
    required this.categoryName,
    required this.categoryId,
  });

  // Get currency controller
  CurrencyController get currencyController => Get.find<CurrencyController>();

  @override
  void onInit() {
    super.onInit();
    _loadCategoryProducts();
  }

  void _loadCategoryProducts() {
    isLoading.value = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Load products based on category
      switch (categoryName.toLowerCase()) {
        case 'carpets':
          _loadCarpetProducts();
          break;
        case 'vinyl':
          _loadVinylProducts();
          break;
        case 'laminate':
          _loadLaminateProducts();
          break;
        case 'wood floor':
          _loadWoodFloorProducts();
          break;
        default:
          _loadAllProducts();
      }

      // Set price range based on actual product prices
      if (allProducts.isNotEmpty) {
        final prices = allProducts.map((p) => p.price).toList();
        minPrice.value =
            prices.reduce((a, b) => a < b ? a : b) - 5; // Add buffer
        maxPrice.value =
            prices.reduce((a, b) => a > b ? a : b) + 5; // Add buffer
      }

      // Apply initial filtering
      _applyFiltersAndSort();

      isLoading.value = false;
    });
  }

  void _loadCarpetProducts() {
    allProducts.value = [
      Product(
        id: 'carpet-1',
        name: 'Premium Carpet',
        description: 'Available in 4m/5m widths',
        price: 35.99,
        imageAsset: AppImages.carpets,
        category: 'Carpet',
        calculatorConfig: ProductCalculatorConfig.carpet(),
      ),
      Product(
        id: 'carpet-2',
        name: 'Luxury Carpet Tiles',
        description: 'Modular carpet system',
        price: 42.50,
        imageAsset: AppImages.carpets,
        category: 'Carpet',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 12.0,
        ),
      ),
      Product(
        id: 'carpet-3',
        name: 'Commercial Carpet',
        description: 'Heavy-duty commercial grade',
        price: 28.99,
        imageAsset: AppImages.carpets,
        category: 'Carpet',
        calculatorConfig: ProductCalculatorConfig.carpet(),
      ),
      Product(
        id: 'carpet-4',
        name: 'Wool Carpet',
        description: 'Natural wool fibers',
        price: 65.00,
        imageAsset: AppImages.carpets,
        category: 'Carpet',
        calculatorConfig: ProductCalculatorConfig.carpet(),
      ),
    ];
  }

  void _loadVinylProducts() {
    allProducts.value = [
      Product(
        id: 'vinyl-1',
        name: 'Luxury vinyl',
        description: '4x6 Sqr. m.',
        price: 29.99,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.vinyl(),
      ),
      Product(
        id: 'vinyl-2',
        name: 'Waterproof Vinyl Plank',
        description: 'Waterproof design',
        price: 38.50,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.vinyl(),
      ),
      Product(
        id: 'vinyl-3',
        name: 'Click Vinyl Flooring',
        description: 'Easy installation',
        price: 32.75,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.vinyl(),
      ),
      Product(
        id: 'vinyl-4',
        name: 'Designer Vinyl Tiles',
        description: 'Premium design collection',
        price: 44.99,
        imageAsset: AppImages.vinyl,
        category: 'Vinyl',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 8.0),
      ),
    ];
  }

  void _loadLaminateProducts() {
    allProducts.value = [
      Product(
        id: 'laminate-1',
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
        id: 'laminate-2',
        name: 'High Gloss Laminate',
        description: 'AC4 rating, scratch resistant',
        price: 34.99,
        imageAsset: AppImages.laminate,
        category: 'Laminate',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 18.0,
        ),
      ),
      Product(
        id: 'laminate-3',
        name: 'Waterproof Laminate',
        description: 'Waterproof core technology',
        price: 41.25,
        imageAsset: AppImages.laminate,
        category: 'Laminate',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 20.0,
        ),
      ),
      Product(
        id: 'laminate-4',
        name: 'Wood Look Laminate',
        description: 'Realistic wood grain texture',
        price: 36.50,
        imageAsset: AppImages.laminate,
        category: 'Laminate',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 16.0,
        ),
      ),
    ];
  }

  void _loadWoodFloorProducts() {
    allProducts.value = [
      Product(
        id: 'wood-1',
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
        id: 'wood-2',
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
        id: 'wood-3',
        name: 'Oak wood',
        description: '5x8 Sqr. m.',
        price: 39.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 40.0,
        ),
      ),
      Product(
        id: 'wood-4',
        name: 'Parquet Premium',
        description: '3x3 Sqr. m.',
        price: 24.99,
        imageAsset: AppImages.parquet2,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(coveragePerBox: 9.0),
      ),
      Product(
        id: 'wood-5',
        name: 'Beige Wood',
        description: '5x7 Sqr. m.',
        price: 45.00,
        imageAsset: AppImages.beige,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 35.0,
        ),
      ),
      Product(
        id: 'wood-6',
        name: 'Engineered Oak',
        description: 'Multi-layer construction',
        price: 52.99,
        imageAsset: AppImages.wood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 22.0,
        ),
      ),
    ];
  }

  void _loadAllProducts() {
    // Load a mix of all products
    allProducts.value = [
      Product(
        id: 'mixed-1',
        name: 'Multi-Surface Flooring',
        description: 'Versatile flooring solution',
        price: 35.99,
        imageAsset: AppImages.laminate,
        category: categoryName,
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 18.0,
        ),
      ),
    ];
  }

  // Actions
  void onProductTap(String productId) {
    final product = allProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => allProducts.first,
    );

    Get.to(
      () => ProductsDetails(product: product),
      transition: Transition.cupertino,
    );
  }

  void onAddToCart(Product product) {
    Get.snackbar(
      'Cart',
      '${product.name} added to cart!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  // Format price for display
  String formatProductPrice(Product product) {
    return '${currencyController.formatPrice(product.price)}/box';
  }

  // Filter and sort methods
  void filterByPrice({double? min, double? max}) {
    if (min != null) minPrice.value = min;
    if (max != null) maxPrice.value = max;

    _applyFiltersAndSort();
  }

  void sortProducts(String sortType) {
    selectedSort.value = sortType;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    // Start with all products
    List<Product> filtered = allProducts.where((product) {
      // Apply price filter
      return product.price >= minPrice.value && product.price <= maxPrice.value;
    }).toList();

    // Apply sorting
    switch (selectedSort.value) {
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'default':
      default:
        // Keep original order
        break;
    }

    filteredProducts.value = filtered;
  }

  // Method to reset filters
  void resetFilters() {
    minPrice.value = 0.0;
    maxPrice.value = 100.0;
    selectedSort.value = 'default';
    _applyFiltersAndSort();
  }
}
