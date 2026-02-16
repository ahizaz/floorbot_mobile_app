import 'dart:io';
import 'package:floor_bot_mobile/app/core/services/ai_service.dart';
import 'package:floor_bot_mobile/app/models/ai_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AiAssistantController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<AiPrompt> prompts = <AiPrompt>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString currentMessage = ''.obs;
  final RxBool hasText = false.obs;
  final RxBool isChatMode = false.obs;
  final RxnString sessionId = RxnString();
  final RxBool isListening = false.obs;
  final RxBool isRecording = false.obs;

  final AiService _aiService = AiService();
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;

  @override
  void onInit() {
    super.onInit();
    _loadPrompts();
    textController.addListener(_onTextChanged);
    _createSession();
  }

  void _onTextChanged() {
    hasText.value = textController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    _endSession();
    _audioRecorder.dispose();
    textController.dispose();
    super.onClose();
  }

  Future<void> _createSession() async {
    EasyLoading.show(status: 'Initializing AI...');
    debugPrint('🎬 Starting AI session...');

    final id = await _aiService.createSession();

    if (id != null) {
      sessionId.value = id;
      debugPrint(' Session initialized: $id');
    } else {
      debugPrint('Failed to initialize session');
      Get.snackbar(
        'Error',
        'Failed to connect to AI',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    EasyLoading.dismiss();
  }

  /// Ensure an AI session exists. Safe to call multiple times; will only
  /// create a new session if none exists.
  Future<void> ensureSession() async {
    if (sessionId.value == null) {
      await _createSession();
    }
  }

  Future<void> _endSession() async {
    if (sessionId.value != null) {
      debugPrint(' Closing AI session...');
      EasyLoading.show(status: 'Closing AI...');

      await _aiService.endSession(sessionId.value!);
      sessionId.value = null;

      EasyLoading.dismiss();
    }
  }

  void _loadPrompts() {
    prompts.value = [
      AiPrompt(
        title: 'Order',
        description: 'Make an order what you\'re looking for',
        icon: '📦',
      ),
      AiPrompt(
        title: 'Carpets',
        description: 'Show the carpets variety',
        icon: '🏠',
      ),
      AiPrompt(
        title: 'Catalogue',
        description: 'Wanna see latest catalogue with pricing',
        icon: '📋',
      ),
      AiPrompt(
        title: 'Quantity Calculator',
        description: 'Help to calculate the quantity of products for flooring',
        icon: '🔢',
      ),
    ];
  }

  void handlePromptTap(AiPrompt prompt) async {
    debugPrint('🤖 AI Prompt tapped: ${prompt.title}');

    // For all prompts, start chat mode
    isChatMode.value = true;

    // Add user message
    final userMessage = ChatMessage(
      text: prompt.description,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    debugPrint('💬 User message added: ${prompt.description}');

    // Get AI response from backend
    await _getAiResponse(prompt.description);
  }

  void handleSend() async {
    if (textController.text.trim().isNotEmpty) {
      final message = textController.text.trim();
      debugPrint('📤 Sending message: $message');

      isChatMode.value = true;

      // Add user message
      final userMessage = ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      );
      messages.add(userMessage);

      textController.clear();
      currentMessage.value = '';

      // Get AI response from backend
      await _getAiResponse(message);
    }
  }

  Future<void> _getAiResponse(String message) async {
    if (sessionId.value == null) {
      Get.snackbar(
        'Error',
        'AI session not initialized',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    EasyLoading.show(status: 'AI is thinking...');
    debugPrint('🤔 AI processing request...');

    final response = await _aiService.sendMessage(sessionId.value!, message);

    if (response != null) {
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);
      debugPrint('✅ AI response added: $response');
    } else {
      debugPrint('❌ Failed to get AI response');
      Get.snackbar(
        'Error',
        'Failed to get AI response',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    EasyLoading.dismiss();
  }

  Future<void> handleVoiceInput() async {
    if (isRecording.value) {
      // Stop recording and transcribe
      await _stopRecording();
      return;
    }

    // Check microphone permission
    final permission = await Permission.microphone.status;
    if (!permission.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        Get.snackbar(
          'Permission Required',
          'Microphone permission is required for voice input',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    // Check if recorder has permission
    if (!await _audioRecorder.hasPermission()) {
      Get.snackbar(
        'Permission Required',
        'Microphone permission is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Start recording
    await _startRecording();
  }

  Future<void> _startRecording() async {
    try {
      debugPrint('🎤 Starting audio recording...');

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordingPath = '${directory.path}/audio_$timestamp.wav';

      // Start recording in WAV format
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          numChannels: 1,
          sampleRate: 16000,
        ),
        path: _recordingPath!,
      );

      isRecording.value = true;
      isListening.value = true;
      debugPrint('✅ Recording started: $_recordingPath');
    } catch (e) {
      debugPrint('❌ Error starting recording: $e');
      Get.snackbar(
        'Error',
        'Failed to start recording',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      debugPrint('🛑 Stopping audio recording...');

      final path = await _audioRecorder.stop();
      isRecording.value = false;
      isListening.value = false;

      if (path != null && File(path).existsSync()) {
        debugPrint('✅ Recording saved: $path');

        // Show transcribing indicator
        EasyLoading.show(status: 'AI is thinking...');

        // Send audio to voice chat endpoint and get full response
        final session = sessionId.value;
        if (session == null) {
          debugPrint('❌ No AI session available for voice message');
          EasyLoading.dismiss();
          return;
        }

        final result = await _aiService.sendVoiceMessage(
          sessionId: session,
          audioPath: path,
          audioFormat: 'wav',
          language: 'en',
        );

        EasyLoading.dismiss();

        if (result != null) {
          debugPrint('✅ Voice API returned: $result');

          final success = result['success'] ?? false;
          final aiResp = result['response'];
          final transcribed = result['transcribed_text'] ?? result['transcribedText'] ?? '';
          final returnedSession = result['session_id'] ?? result['sessionId'];

          if (returnedSession != null) {
            sessionId.value = returnedSession.toString();
            debugPrint('🆔 Updated session id: ${sessionId.value}');
          }

          if (transcribed != null && (transcribed as String).isNotEmpty) {
            textController.text = transcribed as String;
            debugPrint('✅ Transcribed text: $transcribed');
          }

          if (success == true && aiResp != null) {
            final aiMessage = ChatMessage(
              text: aiResp.toString(),
              isUser: false,
              timestamp: DateTime.now(),
            );
            messages.add(aiMessage);
            debugPrint('✅ AI response added: ${aiResp.toString()}');
          } else {
            debugPrint('❌ Voice API returned failure or empty response');
            Get.snackbar(
              'Error',
              'AI did not return a response. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }

          // Delete the audio file after processing
          try {
            await File(path).delete();
            debugPrint('🗑️ Audio file deleted');
          } catch (e) {
            debugPrint('⚠️ Failed to delete audio file: $e');
          }
        } else {
          debugPrint('❌ Voice API call failed (null result)');
          Get.snackbar(
            'Error',
            'Failed to process voice message. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        debugPrint('❌ Recording file not found');
      }
    } catch (e) {
      debugPrint('❌ Error stopping recording: $e');
      isRecording.value = false;
      isListening.value = false;
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Failed to process recording',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void closeSheet() async {
    debugPrint('❌ Closing AI Assistant sheet');
    await _endSession();
    messages.clear();
    isChatMode.value = false;
    textController.clear();
    Get.back();
  }

  void backToPrompts() {
    debugPrint('⬅️ Back to prompts');
    isChatMode.value = false;
    messages.clear();
  }
}
