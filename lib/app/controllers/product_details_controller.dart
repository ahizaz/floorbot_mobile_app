import 'package:floor_bot_mobile/app/controllers/cart_controller.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
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
  final RxString productSize = '4x4 Sqr.m'.obs;
  final RxInt calculatedBoxes = 0.obs;

  late Product product;
  final PageController pageController = PageController();

  void initProduct(Product prod) {
    product = prod;
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
    calculateBoxes();
  }

  void updateWidth(String value) {
    width.value = value;
    calculateBoxes();
  }

  void updateUnit(String value) {
    selectedUnit.value = value;
    calculateBoxes();
  }

  void calculateBoxes() {
    if (length.value.isEmpty || width.value.isEmpty) {
      calculatedBoxes.value = 0;
      return;
    }

    final lengthValue = double.tryParse(length.value);
    final widthValue = double.tryParse(width.value);

    if (lengthValue == null || widthValue == null) {
      calculatedBoxes.value = 0;
      return;
    }

    // Calculate area in square meters (assuming product size is 4x4 = 16 sq.m per box)
    double areaInSqM = lengthValue * widthValue;

    // Convert to square meters if needed
    if (selectedUnit.value == 'Sqr. ft.') {
      areaInSqM = areaInSqM * 0.092903; // Convert sq ft to sq m
    }

    // Calculate number of boxes (assuming each box covers 16 sq.m)
    final boxesNeeded = (areaInSqM / 16).ceil();
    calculatedBoxes.value = boxesNeeded;

    // Calculate quantity of pieces (assuming 20 pcs per calculation as shown in design)
    // This is derived from the area calculation
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
    Get.snackbar(
      'Buy Now',
      'Proceeding to checkout...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
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
