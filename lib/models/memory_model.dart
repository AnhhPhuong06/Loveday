class MemoryModel {
  final String id;
  final String coupleId;
  final String title;
  final String? description;
  final List<String> photoUrls;
  final DateTime eventDate;
  final String category; // 'first_date', 'travel', 'anniversary', 'special'
  final DateTime createdAt;

  MemoryModel({
    required this.id,
    required this.coupleId,
    required this.title,
    this.description,
    this.photoUrls = const [],
    required this.eventDate,
    this.category = 'anniversary',
    required this.createdAt,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'] as String,
      coupleId: json['couple_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      eventDate: DateTime.parse(json['event_date'] as String),
      category: json['category'] as String? ?? 'anniversary',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couple_id': coupleId,
      'title': title,
      'description': description,
      'photo_urls': photoUrls,
      'event_date': eventDate.toIso8601String().split('T')[0],
      'category': category,
    };
  }
}
