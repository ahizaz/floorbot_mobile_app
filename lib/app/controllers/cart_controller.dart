import 'package:floor_bot_mobile/app/models/cart_item.dart';
import 'package:floor_bot_mobile/app/models/product.dart';
import 'package:floor_bot_mobile/app/views/screens/cart/checkout_view.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;

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
    // Add some sample items for testing
    _addSampleItems();
  }

  void _addSampleItems() {
    _cartItems.addAll([
      CartItem(
        id: '1',
        productId: '1',
        name: 'Parquet wooden flooring tiles',
        imageAsset: 'assets/images/parquet.png',
        price: 24.99,
        size: '4x4 Sqr. m.',
        quantity: 1,
      ),
      CartItem(
        id: '2',
        productId: '2',
        name: 'Parquet wooden flooring tiles',
        imageAsset: 'assets/images/parquet.png',
        price: 24.99,
        size: '4x4 Sqr. m.',
        quantity: 1,
      ),
    ]);
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
          price: product.price,
          size: product.description,
          quantity: quantity,
        ),
      );
    }

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
    }
  }

  void decrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      _cartItems.refresh();
    }
  }

  void removeItem(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);

    Get.snackbar(
      'Removed',
      'Item removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void clearCart() {
    _cartItems.clear();
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
