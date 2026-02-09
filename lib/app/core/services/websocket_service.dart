import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:floor_bot_mobile/app/models/notification_model.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final Function(NotificationModel) onNotificationReceived;
  final Function()? onConnected;
  final Function()? onDisconnected;
  final Function(dynamic)? onError;
  
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _reconnectTimer;
  String? _lastToken;

  WebSocketService({
    required this.onNotificationReceived,
    this.onConnected,
    this.onDisconnected,
    this.onError,
  });

  // Connect to WebSocket
  void connect(String token) {
    try {
      _lastToken = token;
      
      final wsUrl = 'ws://10.10.12.15:8089/ws/asc/notifications/?token=$token';
      debugPrint('WebSocketService: Connecting to $wsUrl');
      
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      _subscription = _channel!.stream.listen(
        (data) {
          _isConnected = true;
          debugPrint('WebSocketService: Received data: $data');
          
          try {
            final jsonData = json.decode(data);
            final notification = NotificationModel.fromJson(jsonData);
            debugPrint('WebSocketService: Parsed notification: $notification');
            onNotificationReceived(notification);
          } catch (e) {
            debugPrint('WebSocketService: Error parsing notification: $e');
            onError?.call(e);
          }
        },
        onError: (error) {
          debugPrint('WebSocketService: Connection error: $error');
          _isConnected = false;
          onError?.call(error);
          onDisconnected?.call();
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('WebSocketService: Connection closed');
          _isConnected = false;
          onDisconnected?.call();
          _scheduleReconnect();
        },
      );
      
      // Call onConnected callback
      Future.delayed(Duration(milliseconds: 500), () {
        if (_isConnected) {
          debugPrint('WebSocketService: Connected successfully');
          onConnected?.call();
        }
      });
      
    } catch (e) {
      debugPrint('WebSocketService: Error connecting: $e');
      _isConnected = false;
      onError?.call(e);
      _scheduleReconnect();
    }
  }

  // Schedule reconnection
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: 5), () {
      if (_lastToken != null && !_isConnected) {
        debugPrint('WebSocketService: Attempting to reconnect...');
        connect(_lastToken!);
      }
    });
  }

  // Disconnect from WebSocket
  void disconnect() {
    debugPrint('WebSocketService: Disconnecting...');
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _lastToken = null;
  }

  // Dispose resources
  void dispose() {
    disconnect();
  }
}
