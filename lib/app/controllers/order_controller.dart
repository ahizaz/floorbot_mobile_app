import 'package:floor_bot_mobile/app/models/order.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final RxList<Order> _orders = <Order>[].obs;
  final Rx<Order?> _selectedOrder = Rx<Order?>(null);

  List<Order> get orders => _orders;
  Order? get selectedOrder => _selectedOrder.value;

  List<Order> get inProgressOrders =>
      _orders.where((order) => order.isInProgress).toList();
  List<Order> get completedOrders =>
      _orders.where((order) => !order.isInProgress).toList();

  @override
  void onInit() {
    super.onInit();
    // Add sample orders for testing
    _addSampleOrders();
  }

  void _addSampleOrders() {
    _orders.addAll([
      Order(
        id: '#NGJ357596',
        productId: '1',
        productName: 'Parquet wooden flooring tiles',
        imageAsset: 'assets/images/parquet.png',
        size: '4x4 Sqr. m.',
        unitPrice: 24.99,
        quantity: 1,
        deliveryFee: 10.00,
        tax: 1.00,
        status: OrderStatus.placed,
        paymentMethod: 'Credit Card',
        cardNumber: '2585',
        cardExpiry: '12/27',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Order(
        id: '#NGJ357597',
        productId: '2',
        productName: 'Parquet wooden flooring tiles',
        imageAsset: 'assets/images/parquet.png',
        size: '4x4 Sqr. m.',
        unitPrice: 24.99,
        quantity: 1,
        deliveryFee: 10.00,
        tax: 1.00,
        status: OrderStatus.inTransit,
        paymentMethod: 'Credit Card',
        cardNumber: '2585',
        cardExpiry: '12/27',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);
  }

  void selectOrder(Order order) {
    _selectedOrder.value = order;
  }

  void markAsDelivered(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.delivered);
      _orders.refresh();
    }
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.cancelled);
      _orders.refresh();
    }
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}
