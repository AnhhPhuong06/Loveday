class CoupleModel {
  final String id;
  final String inviteCode;
  final String user1Id;
  final String? user2Id;
  final DateTime anniversaryDate;
  final int currentStreak;
  final int maxStreak;
  final DateTime? lastStreakDate;
  final String? coverImageUrl;
  final String status; // 'pending', 'active'
  final DateTime createdAt;

  CoupleModel({
    required this.id,
    required this.inviteCode,
    required this.user1Id,
    this.user2Id,
    required this.anniversaryDate,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.lastStreakDate,
    this.coverImageUrl,
    this.status = 'pending',
    required this.createdAt,
  });

  /// Tính tổng số ngày yêu nhau từ ngày anniversaryDate đến hiện tại
  int get totalLoveDays {
    final now = DateTime.now();
    return now.difference(anniversaryDate).inDays + 1;
  }

  /// Kiểm tra xem chuỗi hôm nay đã được duy trì hay chưa
  bool get isStreakCompletedToday {
    if (lastStreakDate == null) return false;
    final now = DateTime.now();
    return lastStreakDate!.year == now.year &&
        lastStreakDate!.month == now.month &&
        lastStreakDate!.day == now.day;
  }

  factory CoupleModel.fromJson(Map<String, dynamic> json) {
    return CoupleModel(
      id: json['id'] as String,
      inviteCode: json['invite_code'] as String,
      user1Id: json['user_1_id'] as String,
      user2Id: json['user_2_id'] as String?,
      anniversaryDate: json['anniversary_date'] != null
          ? DateTime.parse(json['anniversary_date'] as String)
          : DateTime.now(),
      currentStreak: json['current_streak'] as int? ?? 0,
      maxStreak: json['max_streak'] as int? ?? 0,
      lastStreakDate: json['last_streak_date'] != null
          ? DateTime.tryParse(json['last_streak_date'] as String)
          : null,
      coverImageUrl: json['cover_image_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invite_code': inviteCode,
      'user_1_id': user1Id,
      'user_2_id': user2Id,
      'anniversary_date': anniversaryDate.toIso8601String(),
      'current_streak': currentStreak,
      'max_streak': maxStreak,
      'last_streak_date': lastStreakDate?.toIso8601String().split('T')[0],
      'cover_image_url': coverImageUrl,
      'status': status,
    };
  }
}
