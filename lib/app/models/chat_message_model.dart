class ChatMessage {
  final String text;
  final MessageSender sender;
  final DateTime createdAt;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      sender: MessageSender.fromJson(json['sender'] ?? {}),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Check if message is from admin (id == 1)
  bool get isAdmin => sender.id == 1;
}

class MessageSender {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;
  final DateTime lastActivity;

  MessageSender({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.lastActivity,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      image: json['image'],
      lastActivity: DateTime.parse(
        json['last_activity'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) {
      return id == 1 ? 'Admin' : 'User';
    }
    return '$firstName $lastName'.trim();
  }
}

class SupportChatResponse {
  final bool success;
  final String statusMessage;
  final InboxData inboxData;
  final List<ChatMessage> messages;

  SupportChatResponse({
    required this.success,
    required this.statusMessage,
    required this.inboxData,
    required this.messages,
  });

  factory SupportChatResponse.fromJson(Map<String, dynamic> json) {
    return SupportChatResponse(
      success: json['success'] ?? false,
      statusMessage: json['status_message'] ?? '',
      inboxData: InboxData.fromJson(json['inbox_data'] ?? {}),
      messages:
          (json['messages'] as List?)
              ?.map((m) => ChatMessage.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class InboxData {
  final int id;
  final String name;
  final List<Participant> participants;
  final LastMessage? lastMessage;
  final DateTime? lastMessageTime;
  final DateTime updatedAt;

  InboxData({
    required this.id,
    required this.name,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    required this.updatedAt,
  });

  factory InboxData.fromJson(Map<String, dynamic> json) {
    return InboxData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      participants:
          (json['participants'] as List?)
              ?.map((p) => Participant.fromJson(p))
              .toList() ??
          [],
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.parse(json['last_message_time'])
          : null,
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Participant {
  final int id;
  final String firstName;
  final String lastName;
  final String? image;
  final DateTime lastActivity;

  Participant({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.lastActivity,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      image: json['image'],
      lastActivity: DateTime.parse(
        json['last_activity'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class LastMessage {
  final int id;
  final String text;
  final String senderName;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.text,
    required this.senderName,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      senderName: json['sender_name'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
