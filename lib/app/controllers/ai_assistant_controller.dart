import 'package:floor_bot_mobile/app/models/ai_prompt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiAssistantController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<AiPrompt> prompts = <AiPrompt>[].obs;
  final RxString currentMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrompts();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
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

  void handlePromptTap(AiPrompt prompt) {
    textController.text = prompt.description;
    currentMessage.value = prompt.description;
    // TODO: Handle AI prompt submission
  }

  void handleSend() {
    if (textController.text.trim().isNotEmpty) {
      final message = textController.text.trim();
      // TODO: Handle AI message send
      Get.snackbar(
        'AI Assistant',
        'Processing: $message',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      textController.clear();
      currentMessage.value = '';
      Get.back();
    }
  }

  void handleVoiceInput() {
    // TODO: Implement voice input functionality
    Get.snackbar(
      'Voice Input',
      'Voice input feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void closeSheet() {
    Get.back();
  }
}
