class PeriodModel {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? endDate;
  final int cycleLength;   // Mặc định 28 ngày
  final int periodLength;  // Mặc định 5 ngày
  final List<String> symptoms; // ['Đau bụng', 'Đau đầu', 'Mệt mỏi', 'Cáu gắt']
  final String? mood;      // 'Vui vẻ', 'Nhạy cảm', 'Cần ôm', 'Mệt'
  final bool notifyPartner; // Cho phép gửi thông báo cho bạn trai
  final String? note;
  final DateTime createdAt;

  PeriodModel({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.cycleLength = 28,
    this.periodLength = 5,
    this.symptoms = const [],
    this.mood,
    this.notifyPartner = true,
    this.note,
    required this.createdAt,
  });

  /// Ngày dự kiến bắt đầu kỳ kinh tiếp theo
  DateTime get nextPeriodDate => startDate.add(Duration(days: cycleLength));

  /// Ngày rụng trứng dự kiến (14 ngày trước kỳ tiếp theo)
  DateTime get ovulationDate => nextPeriodDate.subtract(const Duration(days: 14));

  /// Cửa sổ thụ thai (4 ngày trước và 1 ngày sau rụng trứng)
  DateTime get fertileWindowStart => ovulationDate.subtract(const Duration(days: 4));
  DateTime get fertileWindowEnd => ovulationDate.add(const Duration(days: 1));

  /// Đếm số ngày còn lại đến kỳ tiếp theo
  int get daysUntilNextPeriod {
    final now = DateTime.now();
    final diff = nextPeriodDate.difference(now).inDays;
    return diff >= 0 ? diff : 0;
  }

  /// Kiểm tra xem hôm nay có đang trong kỳ kinh không
  bool get isCurrentlyInPeriod {
    final now = DateTime.now();
    final currentEndDate = endDate ?? startDate.add(Duration(days: periodLength));
    return now.isAfter(startDate.subtract(const Duration(days: 1))) && 
           now.isBefore(currentEndDate.add(const Duration(days: 1)));
  }

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      cycleLength: json['cycle_length'] as int? ?? 28,
      periodLength: json['period_length'] as int? ?? 5,
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      mood: json['mood'] as String?,
      notifyPartner: json['notify_partner'] as bool? ?? true,
      note: json['note'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'cycle_length': cycleLength,
      'period_length': periodLength,
      'symptoms': symptoms,
      'mood': mood,
      'notify_partner': notifyPartner,
      'note': note,
    };
  }
}
