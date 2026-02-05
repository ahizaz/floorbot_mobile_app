import 'dart:convert';
import 'package:floor_bot_mobile/app/models/cart_item.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/views/screens/cart/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  static const String _cartKey = 'cart_items';

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => cartItems.isEmpty ? 0 : 10.00;

  double get tax => subtotal * 0.05; // 5% tax

  double get total => subtotal + deliveryFee + tax;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  // Load cart from SharedPreferences
  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> cartList = jsonDecode(cartJson);
        final items = cartList
            .map((item) => CartItem.fromJson(item))
            .where(
              (item) => !item.isExpired,
            ) // Filter out expired items (24+ hours)
            .toList();

        _cartItems.assignAll(items);

        // If any items were expired, save the filtered list
        if (items.length != cartList.length) {
          await _saveCartToStorage();
          debugPrint(
            'CartController: Removed ${cartList.length - items.length} expired items',
          );
        }

        debugPrint('CartController: Loaded ${items.length} items from storage');
      } else {
        debugPrint('CartController: No saved cart found, starting fresh');
      }
    } catch (e) {
      debugPrint('CartController: Error loading cart from storage: $e');
    }
  }

  // Save cart to SharedPreferences
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = jsonEncode(
        _cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartJson);
      debugPrint('CartController: Saved ${_cartItems.length} items to storage');
    } catch (e) {
      debugPrint('CartController: Error saving cart to storage: $e');
      EasyLoading.showError('Failed to save cart');
    }
  }

  void addToCart(
    Product product, {
    int quantity = 1,
    bool showSnackbar = false,
  }) {
    // Check if product already exists in cart
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex != -1) {
      // Update quantity if product exists
      _cartItems[existingIndex].quantity += quantity;
      _cartItems.refresh();
    } else {
      // Add new item
      _cartItems.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          name: product.name,
          imageAsset: product.imageAsset,
          imageUrl: product.imageUrl,
          price: product.price,
          size: product.description,
          quantity: quantity,
        ),
      );
    }

    // Save to storage
    _saveCartToStorage();

    // Only show snackbar if requested (for quick add from product list)
    if (showSnackbar) {
      Get.snackbar(
        'Success',
        '${product.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void incrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _cartItems[index].quantity++;
      _cartItems.refresh();
      _saveCartToStorage();
    }
  }

  void decrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      _cartItems.refresh();
      _saveCartToStorage();
    }
  }

  void removeItem(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    _saveCartToStorage();

    Get.snackbar(
      'Removed',
      'Item removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void clearCart() {
    _cartItems.clear();
    _saveCartToStorage();
  }

  void proceedToCheckout() {
    if (_cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to cart before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to checkout view
    Get.to(() => const CheckoutView(), transition: Transition.cupertino);
  }
}
