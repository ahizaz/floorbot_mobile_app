class ChatMessage {
  final int id;
  final String message;
  final bool isAdmin;
  final DateTime timestamp;
  final String? senderName;
  final bool isRead;
  ChatMessage({
    required this.id,
    required this.message,
    required this.isAdmin,
    required this.timestamp,
    this.senderName,
    this.isRead = false,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      isAdmin: json['is_admin'] ?? false,
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      senderName: json['sender_name'],
      isRead: json['is_read'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'is_admin': isAdmin,
      'timestamp': timestamp.toIso8601String(),
      'sender_name': senderName,
      'is_read': isRead,
    };
  }
}
