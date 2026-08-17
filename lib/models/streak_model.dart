class StreakModel {
  final String id;
  final String coupleId;
  final String senderId;
  final String photoUrl;
  final String? caption;
  final int streakDayCount;
  final DateTime createdAt;

  StreakModel({
    required this.id,
    required this.coupleId,
    required this.senderId,
    required this.photoUrl,
    this.caption,
    required this.streakDayCount,
    required this.createdAt,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      id: json['id'] as String,
      coupleId: json['couple_id'] as String,
      senderId: json['sender_id'] as String,
      photoUrl: json['photo_url'] as String,
      caption: json['caption'] as String?,
      streakDayCount: json['streak_day_count'] as int? ?? 1,
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
      'photo_url': photoUrl,
      'caption': caption,
      'streak_day_count': streakDayCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
