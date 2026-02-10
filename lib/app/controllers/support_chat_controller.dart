import 'package:floor_bot_mobile/app/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SupportChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int _messageIdCounter = 5;

  @override
  void onInit() {
    super.onInit();
    loadDummyMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Load dummy messages
  void loadDummyMessages() {
    isLoading.value = true;

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      messages.value = [
        ChatMessage(
          id: 1,
          message:
              'Hello! Welcome to Floor Bot Support. How can I help you today?',
          isAdmin: true,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          senderName: 'Admin',
          isRead: true,
        ),
        ChatMessage(
          id: 2,
          message: 'Hi, I need help with my order.',
          isAdmin: false,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 55),
          ),
        ),
        ChatMessage(
          id: 3,
          message:
              'Sure! I\'d be happy to help. Could you please provide your order number?',
          isAdmin: true,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 50),
          ),
          senderName: 'Admin',
          isRead: true,
        ),
        ChatMessage(
          id: 4,
          message: 'My order number is #12345',
          isAdmin: false,
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 45),
          ),
        ),
      ];

      isLoading.value = false;

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    });
  }

  // Send message
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      EasyLoading.showInfo('Please enter a message');
      return;
    }

    try {
      isSending.value = true;

      // Add user message
      final userMessage = ChatMessage(
        id: _messageIdCounter++,
        message: text,
        isAdmin: false,
        timestamp: DateTime.now(),
      );

      messages.add(userMessage);
      messageController.clear();
      scrollToBottom();

      // Simulate admin reply after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        final adminReply = ChatMessage(
          id: _messageIdCounter++,
          message: _getAutoReply(text),
          isAdmin: true,
          timestamp: DateTime.now(),
          senderName: 'Admin',
          isRead: false,
        );

        messages.add(adminReply);
        scrollToBottom();
      });

      debugPrint('SupportChat: Message sent successfully');
    } catch (e) {
      debugPrint('SupportChat: Error sending message: $e');
      EasyLoading.showError('Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  // Get auto reply based on message content
  String _getAutoReply(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('order') || lowerMessage.contains('delivery')) {
      return 'Thank you for reaching out! Our team will check your order status and get back to you shortly. Average response time is 5-10 minutes.';
    } else if (lowerMessage.contains('payment') ||
        lowerMessage.contains('refund')) {
      return 'I understand your concern about payment. Our finance team will review your request and respond within 24 hours.';
    } else if (lowerMessage.contains('product') ||
        lowerMessage.contains('quality')) {
      return 'We appreciate your feedback about our products. Could you please provide more details so we can assist you better?';
    } else if (lowerMessage.contains('hi') || lowerMessage.contains('hello')) {
      return 'Hello! How can I assist you today?';
    } else if (lowerMessage.contains('thanks') ||
        lowerMessage.contains('thank you')) {
      return 'You\'re welcome! Is there anything else I can help you with?';
    } else {
      return 'Thank you for your message. A support agent will respond to you shortly. Please allow 5-10 minutes for a response.';
    }
  }

  // Scroll to bottom
  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  // Refresh messages
  Future<void> refreshMessages() async {
    EasyLoading.show(status: 'Refreshing...');
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.showSuccess('Messages updated');
  }
}
