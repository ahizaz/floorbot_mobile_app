import 'dart:convert';
import 'dart:io';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

      // The backend exposes a `session/delete/` endpoint that accepts a POST
      // with `session_id` in the body. Calling DELETE on `/session/<id>/`
      // returns a 404 from Django in some deployments. Use the documented
      // delete endpoint instead.
      final uri = Uri.parse('${Urls.baseUrl}/ai-fetures/session/delete/');
      final body = json.encode({'session_id': sessionId});

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      debugPrint('📡 Session End Response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Session ended successfully');
        return true;
      }

      // If server returned HTML (Django 404 page) or other unexpected body,
      // avoid logging huge HTML blobs; log a brief message instead.
      debugPrint('❌ Failed to end session (status ${response.statusCode})');
      return false;
    } catch (e) {
      debugPrint('💥 Error ending session: $e');
      return false;
    }
  }

  Future<String?> sendMessage(String sessionId, String message) async {
    try {
      debugPrint('💬 Sending message to AI...');
      debugPrint('📤 Message: $message');
      debugPrint('🆔 Session ID: $sessionId');

      final headers = await _getHeaders();
      final body = json.encode({'message': message, 'session_id': sessionId});

      debugPrint('📦 Request Body: $body');

      final response = await http.post(
        Uri.parse(Urls.chattingwithAi),
        headers: headers,
        body: body,
      );

      debugPrint('📡 Message Response: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final success = data['success'] ?? false;
        final error = data['error'];
        final aiResponse = data['response'];
        final transcribedText = data['transcribed_text'];
        final returnedSessionId = data['session_id'];

        debugPrint('✅ Success: $success');
        debugPrint('🆔 Returned Session ID: $returnedSessionId');
        debugPrint('💬 AI Response: $aiResponse');
        debugPrint('🎤 Transcribed Text: $transcribedText');
        debugPrint('❌ Error: $error');

        if (response.body.isNotEmpty) {
          // Return the full response body so callers can access structured fields like `products`.
          debugPrint('✅ Returning full AI response body');
          return response.body;
        } else {
          debugPrint('❌ Failed - Error: $error');
          return null;
        }
      } else {
        debugPrint('❌ Failed to get AI response: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('💥 Error sending message: $e');
      return null;
    }
  }

  Future<String?> transcribeAudio(String audioPath) async {
    try {
      debugPrint('🎤 Transcribing audio file: $audioPath');

      final token = await _getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Urls.baseUrl}/ai-fetures/transcribe/'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Add the audio file
      final audioFile = await http.MultipartFile.fromPath(
        'audio',
        audioPath,
        contentType: MediaType('audio', 'wav'),
      );
      request.files.add(audioFile);

      debugPrint('📤 Sending audio file for transcription...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📡 Transcription Response: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transcription = data['text'] ?? data['transcription'];
        debugPrint('✅ Transcription received: $transcription');
        return transcription;
      } else {
        debugPrint('❌ Failed to transcribe audio: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('💥 Error transcribing audio: $e');
      return null;
    }
  }

  /// Send recorded audio to the voice chat endpoint and return parsed JSON map
  /// Expected response keys: 'success', 'response', 'transcribed_text', 'session_id'
  Future<Map<String, dynamic>?> sendVoiceMessage({
    required String sessionId,
    required String audioPath,
    String audioFormat = 'wav',
    String language = 'en',
  }) async {
    try {
      debugPrint('🎤 Sending voice message (base64 JSON): $audioPath for session $sessionId');

      // Read and encode audio file as Base64 string to match backend serializer
      final file = File(audioPath);
      if (!await file.exists()) {
        debugPrint('❌ Audio file not found: $audioPath');
        return null;
      }

      final bytes = await file.readAsBytes();
      final base64Audio = base64Encode(bytes);

      final bodyMap = {
        'audio_data': base64Audio,
        'audio_format': audioFormat,
        'session_id': sessionId,
        'language': language,
      };

      final headers = await _getHeaders();
      final body = json.encode(bodyMap);

      debugPrint('📤 Posting JSON to ${Urls.voiceAi} (audio_data length: ${base64Audio.length})');
      final response = await http.post(
        Uri.parse(Urls.voiceAi),
        headers: headers,
        body: body,
      );

      debugPrint('📡 Voice API Response: ${response.statusCode}');
      debugPrint('📄 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        debugPrint('❌ Voice API failed: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('💥 Error sending voice message: $e');
      return null;
    }
  }
}
