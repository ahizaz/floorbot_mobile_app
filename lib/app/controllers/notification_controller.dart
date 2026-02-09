import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:floor_bot_mobile/app/models/notification_model.dart';
import 'package:floor_bot_mobile/app/core/services/websocket_service.dart';
import 'package:floor_bot_mobile/app/core/services/notification_service.dart';

class NotificationController extends GetxController {
  // Notification list
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  // Unseen notification count
final RxInt unseenCount = 0.obs;
  // Loading state
  final RxBool isLoading = false.obs;
  
  // WebSocket service
  WebSocketService? _webSocketService;
  
  // Token
  String? _token;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  @override
  void onClose() {
    _webSocketService?.dispose();
    super.onClose();
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    try {
      // Get token
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('access');
      
      if (_token == null || _token!.isEmpty) {
        debugPrint('NotificationController: No token found');
        return;
      }

      debugPrint('NotificationController: Token: $_token');

      // Fetch notifications from API
      await fetchNotifications();

      // Connect to WebSocket
      _connectWebSocket();
      
    } catch (e) {
      debugPrint('NotificationController: Error initializing: $e');
    }
  }

  // Connect to WebSocket
  void _connectWebSocket() {
    if (_token == null || _token!.isEmpty) {
      debugPrint('NotificationController: Cannot connect to WebSocket, no token');
      return;
    }

    _webSocketService = WebSocketService(
      onNotificationReceived: (notification) {
        debugPrint('NotificationController: New notification received: $notification');
        
        // Add to the beginning of the list
        notifications.insert(0, notification);
        
        // Fetch updated unseen count from backend
        fetchUnseenCount();
        
        // Show a snackbar
        Get.snackbar(
          notification.title,
          notification.content,
          backgroundColor: _getBackgroundColorForType(notification.noteType),
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
        );
      },
      onConnected: () {
        debugPrint('NotificationController: WebSocket connected');
      },
      onDisconnected: () {
        debugPrint('NotificationController: WebSocket disconnected');
      },
      onError: (error) {
        debugPrint('NotificationController: WebSocket error: $error');
      },
    );

    _webSocketService!.connect(_token!);
  }

  // Get background color for notification type
  Color _getBackgroundColorForType(String noteType) {
    switch (noteType.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Fetch notifications from API
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      
      if (_token == null || _token!.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('access');
      }

      if (_token == null || _token!.isEmpty) {
        debugPrint('NotificationController: No token found');
        EasyLoading.showError('Please login first');
        return;
      }

      debugPrint('NotificationController: Fetching notifications...');
      
      final result = await NotificationService.getNotifications(_token!);
      notifications.value = result;
      
      debugPrint('NotificationController: Fetched ${result.length} notifications');
      
      // Also fetch unseen count
      await fetchUnseenCount();
      
    } catch (e) {
      debugPrint('NotificationController: Error fetching notifications: $e');
      EasyLoading.showError('Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  // Get icon for notification type
  IconData getIconForType(String noteType) {
    switch (noteType.toLowerCase()) {
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.notifications;
    }
    
  }

  // Get color for notification type
  Color getColorForType(String noteType) {
    switch (noteType.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Fetch unseen notification count
  Future<void> fetchUnseenCount() async {
    try {
      if (_token == null || _token!.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('access');
      }

      if (_token == null || _token!.isEmpty) {
        debugPrint('NotificationController: No token for unseen count');
        return;
      }

      debugPrint('NotificationController: Fetching unseen count...');
      
      final count = await NotificationService.getUnseenNotificationCount(_token!);
      unseenCount.value = count;
      
      debugPrint('NotificationController: Unseen count: $count');
      
    } catch (e) {
      debugPrint('NotificationController: Error fetching unseen count: $e');
    }
  }
}
