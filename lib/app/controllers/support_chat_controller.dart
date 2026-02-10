import 'dart:convert';
import 'package:floor_bot_mobile/app/core/utils/urls.dart';
import 'package:floor_bot_mobile/app/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SupportChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final Rx<InboxData?> inboxData = Rx<InboxData?>(null);
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  WebSocketChannel? _channel;
  int? _chatId;
  int? _currentUserId;
  String? _currentUserFullName;
  String? _currentUserImage;

  // Track last sent message to prevent duplicates
  String? _lastSentMessage;
  DateTime? _lastSentTime;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    _channel?.sink.close();
    super.onClose();
  }

  // Initialize chat
  Future<void> _initializeChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getInt('user_id');
      _currentUserFullName = prefs.getString('full_name');
      _currentUserImage = prefs.getString('image');

      debugPrint('SupportChat: 🔍 Checking SharedPreferences...');
      debugPrint('SupportChat: Current User ID: $_currentUserId');
      debugPrint('SupportChat: Current User Name: $_currentUserFullName');
      debugPrint('SupportChat: Current User Image: $_currentUserImage');

      if (_currentUserId == null) {
        debugPrint(
          'SupportChat: ⚠️ User ID is NULL! Will extract from participants...',
        );
      }

      await fetchChatMessages();
      await _connectWebSocket();
    } catch (e) {
      debugPrint('SupportChat: ❌ Error initializing chat: $e');
      EasyLoading.showError('Failed to initialize chat');
    }
  }

  // Fetch chat messages from API
  Future<void> fetchChatMessages() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading messages...');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';

      final response = await http
          .get(
            Uri.parse(Urls.supportmessage),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final chatResponse = SupportChatResponse.fromJson(jsonData);

        inboxData.value = chatResponse.inboxData;
        messages.value = chatResponse.messages;
        _chatId = chatResponse.inboxData.id;

        // Extract current user from participants (admin has ID = 1)
        if (_currentUserId == null) {
          debugPrint(
            'SupportChat: Participants count: ${chatResponse.inboxData.participants.length}',
          );
          for (var p in chatResponse.inboxData.participants) {
            debugPrint(
              'SupportChat: Participant - ID: ${p.id}, Name: ${p.firstName} ${p.lastName}',
            );
          }

          final currentUser = chatResponse.inboxData.participants.firstWhere(
            (p) => p.id != 1, // Not admin
            orElse: () => chatResponse.inboxData.participants.first,
          );
          _currentUserId = currentUser.id;
          _currentUserFullName =
              '${currentUser.firstName} ${currentUser.lastName}'.trim();
          _currentUserImage = currentUser.image;

          // Save to SharedPreferences for future use
          await prefs.setInt('user_id', _currentUserId!);
          if (_currentUserFullName != null &&
              _currentUserFullName!.isNotEmpty) {
            await prefs.setString('full_name', _currentUserFullName!);
          }
          if (_currentUserImage != null) {
            await prefs.setString('image', _currentUserImage!);
          }

          debugPrint(
            'SupportChat: ✅ Extracted User ID from participants: $_currentUserId',
          );
          debugPrint('SupportChat: ✅ User Name: $_currentUserFullName');
          debugPrint('SupportChat: ✅ User Image: $_currentUserImage');
        } else {
          debugPrint('SupportChat: ℹ️ User ID already set: $_currentUserId');
        }

        debugPrint('SupportChat: Chat ID: $_chatId');
        debugPrint('SupportChat: Loaded ${messages.length} messages');

        EasyLoading.dismiss();

        // Scroll to bottom after loading
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });
      } else {
        debugPrint('SupportChat: Failed - Status: ${response.statusCode}');
        EasyLoading.showError('Failed to load messages');
      }
    } catch (e) {
      debugPrint('SupportChat: Error: $e');
      EasyLoading.showError('Failed to load messages');
    } finally {
      isLoading.value = false;
    }
  }

  // Connect to WebSocket
  Future<void> _connectWebSocket() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';

      if (token.isEmpty) {
        debugPrint('SupportChat: No access token available');
        return;
      }

      final wsUrl =
          'ws://10.10.12.15:8089/ws/asc/update_chat_messages/?token=$token';
      debugPrint('SupportChat: Connecting to WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen to messages
      _channel!.stream.listen(
        (data) {
          debugPrint('SupportChat: WebSocket message received');
          _handleWebSocketMessage(data);
        },
        onError: (error) {
          debugPrint('SupportChat: WebSocket error: $error');
        },
        onDone: () {
          debugPrint('SupportChat: WebSocket connection closed');
        },
      );

      debugPrint('SupportChat: WebSocket connected successfully');
    } catch (e) {
      debugPrint('SupportChat: WebSocket connection failed: $e');
      EasyLoading.showError('Failed to connect');
    }
  }

  // Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data);
      debugPrint('SupportChat: Parsed message: $jsonData');

      // Message format: {"id": 8, "chat_id": 3, "sender_id": 10, "message": "text"}
      final chatId = jsonData['chat_id'] ?? 0;
      final senderId = jsonData['sender_id'] ?? 0;
      final messageText = jsonData['message'] ?? '';

      debugPrint(
        'SupportChat: 📩 Received - Chat ID: $chatId, Sender ID: $senderId (${senderId.runtimeType}), Current User ID: $_currentUserId (${_currentUserId.runtimeType})',
      );
      debugPrint(
        'SupportChat: 🔍 Comparison: senderId ($senderId) == _currentUserId ($_currentUserId) = ${senderId == _currentUserId}',
      );

      // Only add if it's for this chat
      if (chatId == _chatId) {
        // Enhanced duplicate detection
        // 1. Check if this is the message we just sent (regardless of sender_id)
        if (messageText == _lastSentMessage &&
            _lastSentTime != null &&
            DateTime.now().difference(_lastSentTime!).inSeconds < 5) {
          debugPrint(
            'SupportChat: ⏭️ Skipping duplicate - this is our sent message echo (sender: $senderId)',
          );
          _lastSentMessage = null; // Clear after detecting
          _lastSentTime = null;
          return;
        }

        // 2. Check if exact same message text already exists (within time window)
        final isDuplicate = messages.any(
          (msg) =>
              msg.text == messageText &&
              DateTime.now().difference(msg.createdAt).inSeconds < 10,
        );

        if (isDuplicate) {
          debugPrint('SupportChat: ⏭️ Skipping duplicate message text');
          return;
        }

        // Get sender info from participants or use current user info
        MessageSender sender;
        if (senderId == _currentUserId) {
          debugPrint('SupportChat: ✅ Message from CURRENT USER (right side)');
          // Current user - use stored profile info
          sender = MessageSender(
            id: senderId,
            firstName: _currentUserFullName?.split(' ').first ?? 'User',
            lastName: _currentUserFullName?.split(' ').skip(1).join(' ') ?? '',
            image: _currentUserImage,
            lastActivity: DateTime.now(),
          );
        } else {
          debugPrint(
            'SupportChat: ⬅️ Message from OTHER USER/ADMIN (left side)',
          );
          // Other participant - try to find from participants list
          final participant = inboxData.value?.participants.firstWhere(
            (p) => p.id == senderId,
            orElse: () => Participant(
              id: senderId,
              firstName: 'Admin',
              lastName: '',
              image: null,
              lastActivity: DateTime.now(),
            ),
          );
          sender = MessageSender(
            id: participant!.id,
            firstName: participant.firstName,
            lastName: participant.lastName,
            image: participant.image,
            lastActivity: participant.lastActivity,
          );
        }

        final newMessage = ChatMessage(
          text: messageText,
          sender: sender,
          createdAt: DateTime.now(),
        );

        messages.add(newMessage);
        scrollToBottom();

        debugPrint('SupportChat: New message added from sender: $senderId');
      }
    } catch (e) {
      debugPrint('SupportChat: Error handling WebSocket message: $e');
    }
  }

  // Send message via WebSocket
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      EasyLoading.showInfo('Please enter a message');
      return;
    }

    if (_channel == null) {
      debugPrint('SupportChat: WebSocket not connected');
      EasyLoading.showError('Connection not available');
      return;
    }

    if (_chatId == null) {
      debugPrint('SupportChat: Chat ID not available');
      EasyLoading.showError('Chat not initialized');
      return;
    }

    try {
      isSending.value = true;

      debugPrint('SupportChat: 📤 Sending message as User ID: $_currentUserId');
      debugPrint('SupportChat: 📤 User Name: $_currentUserFullName');

      // Store message info to detect WebSocket echo
      _lastSentMessage = text;
      _lastSentTime = DateTime.now();

      // Add message locally BEFORE sending to WebSocket for instant UI update
      final tempMessage = ChatMessage(
        text: text,
        sender: MessageSender(
          id: _currentUserId ?? 0,
          firstName: _currentUserFullName?.split(' ').first ?? 'User',
          lastName: _currentUserFullName?.split(' ').skip(1).join(' ') ?? '',
          image: _currentUserImage,
          lastActivity: DateTime.now(),
        ),
        createdAt: DateTime.now(),
      );

      messages.add(tempMessage);
      messageController.clear();
      scrollToBottom();

      // Send message format: {"message":"text", "chat_id":3}
      final messageData = {'message': text, 'chat_id': _chatId};

      debugPrint('SupportChat: Sending to WebSocket: $messageData');

      _channel!.sink.add(jsonEncode(messageData));

      debugPrint('SupportChat: ✅ Message sent successfully');
    } catch (e) {
      debugPrint('SupportChat: ❌ Error sending message: $e');
      EasyLoading.showError('Failed to send message');
    } finally {
      isSending.value = false;
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
    debugPrint('SupportChat: Refreshing messages...');

    // Clear tracking variables
    _lastSentMessage = null;
    _lastSentTime = null;

    EasyLoading.show(status: 'Refreshing...');
    await fetchChatMessages();
  }

  // Check if message is from current user
  bool isMyMessage(int senderId) {
    final result = senderId == _currentUserId;
    debugPrint(
      'SupportChat: isMyMessage($senderId) == $_currentUserId ? $result',
    );
    return result;
  }

  // Get current user ID
  int? get currentUserId => _currentUserId;

  // Get admin name from participants
  String getAdminName() {
    if (inboxData.value == null) return 'Admin';

    final admin = inboxData.value!.participants.firstWhere(
      (p) => p.id == 1,
      orElse: () => Participant(
        id: 1,
        firstName: 'Admin',
        lastName: '',
        image: null,
        lastActivity: DateTime.now(),
      ),
    );

    return '${admin.firstName} ${admin.lastName}'.trim().isEmpty
        ? 'Admin'
        : '${admin.firstName} ${admin.lastName}'.trim();
  }
}
