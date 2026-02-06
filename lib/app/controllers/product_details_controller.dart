import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/controllers/currency_controller.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/models/product_calculator_config.dart';
import 'package:floor_bot_mobile/app/views/screens/cart/checkout_view.dart';
import 'package:floor_bot_mobile/app/views/widgets/product_details/add_to_cart_success_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final RxInt quantity = 1.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isDetailsExpanded = false.obs;
  final RxBool isReturnPolicyExpanded = false.obs;
  final RxBool isCalculatorExpanded = false.obs;

  // Floor calculator properties
  final RxString length = ''.obs;
  final RxString width = ''.obs;
  final RxString selectedUnit = 'Sqr. m.'.obs;
  final Rx<SheetWidth?> selectedWidth = Rx<SheetWidth?>(null);
  final RxDouble calculatedArea = 0.0.obs;
  final RxInt calculatedBoxes = 0.obs;
  final RxString calculationResult = ''.obs;

  late Product product;
  final PageController pageController = PageController();

  // Get currency controller
  CurrencyController get currencyController => Get.find<CurrencyController>();

  void initProduct(Product prod) {
    product = prod;

    // Auto-expand calculator if enabled for this product
    if (product.calculatorConfig.calculatorType == CalculatorType.enabled) {
      isCalculatorExpanded.value = true;
    }

    // Initialize width selection for sheet-based products
    if (product.calculatorConfig.productType == ProductType.carpet) {
      selectedWidth.value = SheetWidth.getCarpetWidths().first;
    } else if (product.calculatorConfig.productType == ProductType.vinyl) {
      selectedWidth.value = SheetWidth.getVinylWidths().first;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null && parsed > 0) {
      quantity.value = parsed;
    }
  }

  double get estimatedCost => product.price * quantity.value;

  String get formattedPrice => currencyController.formatPrice(product.price);
  String get formattedEstimatedCost =>
      currencyController.formatPrice(estimatedCost);

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  void toggleDetails() {
    isDetailsExpanded.value = !isDetailsExpanded.value;
  }

  void toggleReturnPolicy() {
    isReturnPolicyExpanded.value = !isReturnPolicyExpanded.value;
  }

  void toggleCalculator() {
    isCalculatorExpanded.value = !isCalculatorExpanded.value;
  }

  void updateLength(String value) {
    length.value = value;
    calculateResults();
  }

  void updateWidth(String value) {
    width.value = value;
    calculateResults();
  }

  void updateUnit(String value) {
    selectedUnit.value = value;
    calculateResults();
  }

  void updateSelectedWidth(SheetWidth? width) {
    selectedWidth.value = width;
    calculateResults();
  }

  void calculateResults() {
    final config = product.calculatorConfig;

    if (config.calculatorType == CalculatorType.disabled) {
      _resetCalculation();
      return;
    }

    final lengthValue = double.tryParse(length.value);
    if (lengthValue == null || lengthValue <= 0) {
      _resetCalculation();
      return;
    }

    double roomArea = 0.0;

    switch (config.productType) {
      case ProductType.boxBased:
        final widthValue = double.tryParse(width.value);
        if (widthValue == null || widthValue <= 0) {
          _resetCalculation();
          return;
        }

        // 1️⃣ Area
        roomArea = lengthValue * widthValue;

        if (selectedUnit.value == 'Sqr. ft.') {
          roomArea *= 0.092903;
        }

        // 2️⃣ Waste
        final wasteFactor = 1 + (config.wastePercentage / 100);
        final areaWithWaste = roomArea * wasteFactor;

        // 3️⃣ Box coverage (MUST exist)
        final coveragePerBox = config.coveragePerBox;
        if (coveragePerBox == null || coveragePerBox <= 0) {
          _resetCalculation();
          return;
        }

        // 4️⃣ Box calculation
        final exactBoxes = areaWithWaste / coveragePerBox;
        final boxesNeeded = exactBoxes.ceil();

        // 5️⃣ Store result
        calculatedArea.value = areaWithWaste;
        calculatedBoxes.value = boxesNeeded;

        calculationResult.value =
            'Room: ${roomArea.toStringAsFixed(1)} m²\n'
            'With ${config.wastePercentage.toInt()}% waste: ${areaWithWaste.toStringAsFixed(1)} m²\n'
            'Boxes needed: $boxesNeeded (${exactBoxes.toStringAsFixed(2)} calculated)';
        break;

      case ProductType.carpet:
      case ProductType.vinyl:
        if (selectedWidth.value == null) {
          _resetCalculation();
          return;
        }

        final sheetWidth = selectedWidth.value!.width;
        double area = lengthValue * sheetWidth;

        if (selectedUnit.value == 'Sqr. ft.') {
          area *= 0.092903;
        }

        final areaWithWaste = area * (1 + config.wastePercentage / 100);

        calculatedArea.value = areaWithWaste;

        calculationResult.value =
            'You need ${lengthValue.toStringAsFixed(1)}m × ${sheetWidth}m\n'
            'Total with waste: ${areaWithWaste.toStringAsFixed(1)} m²';
        break;

      default:
        _resetCalculation();
    }
  }

  void _resetCalculation() {
    calculatedArea.value = 0.0;
    calculatedBoxes.value = 0;
    calculationResult.value = '';
  }

  void addToCart() {
    // Add product to cart
    try {
      final cartController = Get.find<CartController>();
      cartController.addToCart(product, quantity: quantity.value);
    } catch (e) {
      // If cart controller doesn't exist, create it
      final cartController = Get.put(CartController());
      cartController.addToCart(product, quantity: quantity.value);
    }

    // Show success modal
    AddToCartSuccessModal.show();
  }

  void buyNow() {
    // Add product to cart
    try {
      final cartController = Get.find<CartController>();
      cartController.addToCart(product, quantity: quantity.value);
    } catch (e) {
      // If cart controller doesn't exist, create it
      final cartController = Get.put(CartController());
      cartController.addToCart(product, quantity: quantity.value);
    }

    // Navigate to checkout
    Get.to(() => const CheckoutView());
  }

  void share() {
    Get.snackbar(
      'Share',
      'Sharing ${product.name}...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
