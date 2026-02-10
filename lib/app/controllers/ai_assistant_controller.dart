import 'package:floor_bot_mobile/app/core/services/ai_service.dart';
import 'package:floor_bot_mobile/app/models/ai_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

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

  final AiService _aiService = AiService();

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
    textController.dispose();
    super.onClose();
  }

  Future<void> _createSession() async {
    EasyLoading.show(status: 'Initializing AI...');
    debugPrint('🎬 Starting AI session...');

    final id = await _aiService.createSession();

    if (id != null) {
      sessionId.value = id;
      debugPrint('✅ Session initialized: $id');
    } else {
      debugPrint('❌ Failed to initialize session');
      Get.snackbar(
        'Error',
        'Failed to connect to AI',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    EasyLoading.dismiss();
  }

  Future<void> _endSession() async {
    if (sessionId.value != null) {
      debugPrint('🔚 Closing AI session...');
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

  void handleVoiceInput() {
    debugPrint('🎤 Voice input requested');
    Get.snackbar(
      'Voice Input',
      'Voice input feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
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
