import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/core/utils/app_images.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/products/products_details.dart';
import 'package:floor_bot_mobile/app/views/screens/category/category_products_screen.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  // Observable lists
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Product> newArrivals = <Product>[].obs;
  final RxList<Product> bestDeals = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
    _loadNewArrivals();
    _loadBestDeals();
  }

  void _loadCategories() {
    categories.value = [
      Category(id: '1', name: 'Carpets', imageAsset: AppImages.carpets),
      Category(id: '2', name: 'Vinyl', imageAsset: AppImages.vinyl),
      Category(id: '3', name: 'Laminate', imageAsset: AppImages.laminate),
      Category(id: '4', name: 'Wood Floor', imageAsset: AppImages.wood),
    ];
  }

  void _loadNewArrivals() {
    newArrivals.value = [
      Product(
        id: '1',
        name: 'Solid wood',
        description: '4x7 Sqr. m.',
        price: 39.00,
        imageAsset: AppImages.solidWood,
        category: 'Wood Floor',
        calculatorConfig: ProductCalculatorConfig.boxBased(
          coveragePerBox: 28.0, // 4x7 coverage per box
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
          coveragePerBox: 16.0, // 4x4 coverage per box
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
          coveragePerBox: 15.0, // 3x5 coverage per box
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
          coveragePerBox: 35.0, // 5x7 coverage per box
        ),
      ),
    ];
  }

  void _loadBestDeals() {
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

  void onProductTap(String productId) {
    // Find the product and navigate to details
    final product = [
      ...newArrivals,
      ...bestDeals,
    ].firstWhere((p) => p.id == productId, orElse: () => newArrivals.first);

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

  void onShowAllNewArrivals() {
    // TODO: Navigate to all new arrivals
    Get.snackbar(
      'New Arrivals',
      'Showing all new arrivals...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onShowAllBestDeals() {
    // TODO: Navigate to all best deals
    Get.snackbar(
      'Best Deals',
      'Showing all best deals...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Format price for display
  String formatProductPrice(Product product) {
    return '${Get.find<CurrencyController>().formatPrice(product.price)}/box';
  }
}
