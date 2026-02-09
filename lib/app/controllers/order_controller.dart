import 'dart:convert';

import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
   fetchOrders();
  }

  // void _addSampleOrders() {
  //   _orders.addAll([
  //     Order(
  //       id: '#NGJ357596',
  //       productId: '1',
  //       productName: 'Parquet wooden flooring tiles',
  //       imageAsset: 'assets/images/parquet.png',
  //       size: '4x4 Sqr. m.',
  //       unitPrice: 24.99,
  //       quantity: 1,
  //       deliveryFee: 10.00,
  //       tax: 1.00,
  //       status: OrderStatus.placed,
  //       paymentMethod: 'Credit Card',
  //       cardNumber: '2585',
  //       cardExpiry: '12/27',
  //       orderDate: DateTime.now().subtract(const Duration(days: 2)),
  //     ),
  //     Order(
  //       id: '#NGJ357597',
  //       productId: '2',
  //       productName: 'Parquet wooden flooring tiles',
  //       imageAsset: 'assets/images/parquet.png',
  //       size: '4x4 Sqr. m.',
  //       unitPrice: 24.99,
  //       quantity: 1,
  //       deliveryFee: 10.00,
  //       tax: 1.00,
  //       status: OrderStatus.inTransit,
  //       paymentMethod: 'Credit Card',
  //       cardNumber: '2585',
  //       cardExpiry: '12/27',
  //       orderDate: DateTime.now().subtract(const Duration(days: 5)),
  //     ),
  //   ]);
  // }
   Future<void> fetchOrders() async {
  try {
    EasyLoading.show(status: 'Loading orders...');
    
    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access') ?? '';
    
    debugPrint('OrderController: Token: $token');
    debugPrint('OrderController: Fetching orders from ${Urls.userOrders}');
    
    // API call
    final response = await http.get(
      Uri.parse(Urls.userOrders),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 30));
    
    debugPrint('OrderController: Status Code: ${response.statusCode}');
    debugPrint('OrderController: Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      
      if (jsonData['success'] == true && jsonData['data'] != null) {
        final List<dynamic> ordersData = jsonData['data'];
        
        // Clear existing orders
        _orders.clear();
        
        // Parse and add orders
        for (var orderJson in ordersData) {
          try {
            final order = Order.fromJson(orderJson);
            _orders.add(order);
            debugPrint('OrderController: Added order ${order.id}');
          } catch (e) {
            debugPrint('OrderController: Error parsing order: $e');
          }
        }
        
        debugPrint('OrderController: Total orders loaded: ${_orders.length}');
        EasyLoading.dismiss();
      } else {
        debugPrint('OrderController: Invalid response format');
        EasyLoading.showError('Failed to load orders');
      }
    } else {
      debugPrint('OrderController: Failed with status ${response.statusCode}');
      EasyLoading.showError('Failed to load orders');
    }
  } catch (e) {
    debugPrint('OrderController: Error fetching orders: $e');
    EasyLoading.showError('Error: $e');
  }
}

  void selectOrder(Order order) {
    _selectedOrder.value = order;
  }

  // void markAsDelivered(String orderId) {
  //   final index = _orders.indexWhere((order) => order.id == orderId);
  //   if (index != -1) {
  //     _orders[index] = _orders[index].copyWith(status: OrderStatus.delivered);
  //     _orders.refresh();
  //   }
  // }
   Future<void>markAsDelivered(String orderId)async{
    try{
      EasyLoading.show(status: 'Updating delivery status...');
      debugPrint('OrderController:Marking order $orderId as delivered');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access')??'';
      debugPrint('OrderController :Token $token');
      final clearOrderId = orderId.replaceAll('#','');
      final body =jsonEncode({
       "order_id":int .parse(clearOrderId),
       "delivary_status":"delivered"

      });
    debugPrint('OrderController: Request Body: $body');
    debugPrint('OrderController: API URL: ${Urls.confirmDelivery}');
    final response = await http.patch(
         Uri.parse(Urls.confirmDelivery),
         headers: {
          'Content-Type':'application/json',
          'Authorization':'Bearer $token',
         },body: body,
    ).timeout(const Duration(seconds: 30));
       debugPrint('OrderController: Status Code: ${response.statusCode}');
    debugPrint('OrderController: Response Body: ${response.body}');
     if (response.statusCode == 200 || response.statusCode == 201) {
      // Success - update local state
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: OrderStatus.delivered);
        _orders.refresh();
      }
      
      EasyLoading.showSuccess('Order marked as delivered!');
      debugPrint('OrderController: Order successfully marked as delivered');
    }
     else {
      EasyLoading.showError('Failed to update delivery status');
      debugPrint('OrderController: Failed with status ${response.statusCode}');
    }

    }
    catch (e) {
    debugPrint('OrderController: Error marking as delivered: $e');
    EasyLoading.showError('Error: $e');
  }
   }
     Future<void>submitFeedback(String orderId,String feedbackText,double rating)async{
    try{
      EasyLoading.show(status: 'Submitting feedback...');
      debugPrint('OrderController :Submitting feedback for orderId $orderId');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access')??'';
      debugPrint('OrderController :Token $token');
      final cleanOrderId = orderId.replaceAll('#', '');
      final body = jsonEncode({
      "order_id":int.parse(cleanOrderId),
      "feedback":feedbackText,
      });
      debugPrint('OrderController : Request Body :$body');
      debugPrint('OrderController :API URL: ${Urls.feedBack}');
      final response = await http.put( 
     Uri.parse(Urls.feedBack),
     headers: {
      'Content-Type' : 'application/json',
      'Authorization':'Bearer $token',
     },
     body: body,
      ).timeout(const Duration(seconds: 30));
      debugPrint('OrderController :Status Code :${response.statusCode}');
      debugPrint('OrderController:Response Body:${response.body}');
      if(response.statusCode==200 || response.statusCode==201){
      EasyLoading.showSuccess('Feedback submitted successfully!');
      debugPrint('OrderController: Feedback submitted successfully');
      }else{
      EasyLoading.showError('Failed to submit feedback');
      debugPrint('OrderController: Failed with status ${response.statusCode}');
      }
      
    }catch(e){
     debugPrint('OrderController: Error submitting feedback: $e');
    EasyLoading.showError('Error: $e');  
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
