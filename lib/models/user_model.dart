class UserModel {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? gender; // 'male', 'female', 'other'
  final DateTime? birthDate;
  final String? coupleId;
  final String? fcmToken;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.gender,
    this.birthDate,
    this.coupleId,
    this.fcmToken,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String? ?? 'Người yêu',
      avatarUrl: json['avatar_url'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      coupleId: json['couple_id'] as String?,
      fcmToken: json['fcm_token'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String().split('T')[0],
      'couple_id': coupleId,
      'fcm_token': fcmToken,
    };
  }

  UserModel copyWith({
    String? displayName,
    String? avatarUrl,
    String? gender,
    DateTime? birthDate,
    String? coupleId,
    String? fcmToken,
  }) {
    return UserModel(
      id: id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      coupleId: coupleId ?? this.coupleId,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt,
    );
  }
}
