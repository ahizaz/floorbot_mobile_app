import 'dart:convert';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String?> createSession() async {
    try {
      debugPrint('🚀 Creating AI session...');

      final headers = await _getHeaders();
      final token = await _getToken();
      debugPrint('🔑 Token: ${token?.substring(0, 20)}...');

      final response = await http.post(
        Uri.parse(Urls.sessionCreate),
        headers: headers,
      );

      debugPrint('📡 Session Create Response: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final sessionId = data['session_id'] ?? data['id'];
        debugPrint('✅ Session created successfully: $sessionId');
        return sessionId;
      } else {
        debugPrint('❌ Failed to create session: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('💥 Error creating session: $e');
      return null;
    }
  }

  Future<bool> endSession(String sessionId) async {
    try {
      debugPrint('🛑 Ending AI session: $sessionId');

      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${Urls.baseUrl}/ai-fetures/session/$sessionId/'),
        headers: headers,
      );

      debugPrint('📡 Session End Response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Session ended successfully');
        return true;
      } else {
        debugPrint('❌ Failed to end session: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('💥 Error ending session: $e');
      return false;
    }
  }

  Future<String?> sendMessage(String sessionId, String message) async {
    try {
      debugPrint('💬 Sending message to AI...');

      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/ai-fetures/session/$sessionId/message/'),
        headers: headers,
        body: json.encode({'message': message}),
      );

      debugPrint('📡 Message Response: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiResponse = data['response'] ?? data['message'];
        debugPrint('✅ AI response received');
        return aiResponse;
      } else {
        debugPrint('❌ Failed to get AI response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('💥 Error sending message: $e');
      return null;
    }
  }
}
