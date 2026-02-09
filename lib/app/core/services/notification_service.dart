import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:floor_bot_mobile/app/models/notification_model.dart';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';

class NotificationService {
  // Fetch all notifications
  static Future<List<NotificationModel>> getNotifications(String token) async {
    try {
      debugPrint('NotificationService: Fetching notifications...');
      debugPrint('NotificationService: URL: ${Urls.notification}');
      debugPrint('NotificationService: Token: $token');

      final response = await http.get(
        Uri.parse(Urls.notification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('NotificationService: Status Code: ${response.statusCode}');
      debugPrint('NotificationService: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> notificationsJson = jsonData['data'];
          final notifications = notificationsJson
              .map((json) => NotificationModel.fromJson(json))
              .toList();
          
          debugPrint('NotificationService: Fetched ${notifications.length} notifications');
          return notifications;
        } else {
          debugPrint('NotificationService: Invalid response format');
          return [];
        }
      } else {
        debugPrint('NotificationService: Error ${response.statusCode}: ${response.body}');
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('NotificationService: Exception: $e');
      rethrow;
    }
  }
}
