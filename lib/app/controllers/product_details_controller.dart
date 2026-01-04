import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final RxInt quantity = 1.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isDetailsExpanded = false.obs;
  final RxBool isReturnPolicyExpanded = false.obs;
  final RxBool isCalculatorExpanded = false.obs;

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

  void addToCart() {
    Get.snackbar(
      'Cart',
      '${product.name} (${quantity.value}) added to cart!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
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
