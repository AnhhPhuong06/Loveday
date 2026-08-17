class MessageModel {
  final String id;
  final String coupleId;
  final String senderId;
  final String? text;
  final String? mediaUrl;
  final String type; // 'text', 'image', 'voice', 'sticker', 'love_note'
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.coupleId,
    required this.senderId,
    this.text,
    this.mediaUrl,
    this.type = 'text',
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      coupleId: json['couple_id'] as String,
      senderId: json['sender_id'] as String,
      text: json['text'] as String?,
      mediaUrl: json['media_url'] as String?,
      type: json['type'] as String? ?? 'text',
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couple_id': coupleId,
      'sender_id': senderId,
      'text': text,
      'media_url': mediaUrl,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
