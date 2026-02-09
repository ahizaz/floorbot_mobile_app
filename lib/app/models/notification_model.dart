class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String noteType;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.noteType,
  });

  // Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      noteType: json['note_type'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'note_type': noteType,
    };
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, content: $content, noteType: $noteType)';
  }
}
