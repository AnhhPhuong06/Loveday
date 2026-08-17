import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/period_model.dart';

class PeriodService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  PeriodModel? _currentLog;
  List<PeriodModel> _history = [];
  bool _isLoading = false;

  PeriodModel? get currentLog => _currentLog;
  List<PeriodModel> get history => _history;
  bool get isLoading => _isLoading;

  /// Lời khuyên & thông báo cho người yêu theo từng giai đoạn chu kỳ
  String get partnerAdvice {
    if (_currentLog == null) {
      return "Chưa có dữ liệu chu kỳ. Hãy nhắc người yêu cập nhật nhé!";
    }

    if (_currentLog!.isCurrentlyInPeriod) {
      return "🩸 Người yêu đang trong kỳ đèn đỏ! Hãy mua trà gừng ấm, túi chườm nóng và dịu dàng chăm sóc cô ấy nhé ❤️";
    }

    final daysLeft = _currentLog!.daysUntilNextPeriod;
    if (daysLeft <= 3) {
      return "⚠️ Còn $daysLeft ngày nữa là đến kỳ mới! Cô ấy có thể nhạy cảm hoặc mệt mỏi, hãy kiên nhẫn và chuẩn bị sẵn đồ ngọt nhé 🍫";
    }

    final now = DateTime.now();
    if (now.isAfter(_currentLog!.fertileWindowStart) && now.isBefore(_currentLog!.fertileWindowEnd)) {
      return "🌸 Đang trong giai đoạn rụng trứng / cửa sổ thụ thai.";
    }

    return "✨ Trạng thái bình thường. Hãy tạo nhiều khoảnh khắc vui vẻ cùng nhau nhé!";
  }

  /// Tải thông tin chu kỳ gần nhất
  Future<void> loadPeriodData(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _supabase
          .from('period_logs')
          .select()
          .eq('user_id', userId)
          .order('start_date', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data != null) {
        _currentLog = PeriodModel.fromJson(data);
      } else {
        // Mock data khởi tạo
        _currentLog = PeriodModel(
          id: 'log_mock',
          userId: userId,
          startDate: DateTime.now().subtract(const Duration(days: 20)),
          cycleLength: 28,
          periodLength: 5,
          symptoms: ['Mệt nhẹ', 'Thèm ngọt 🍰'],
          mood: 'Vui vẻ',
          notifyPartner: true,
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Load Period Error: $e');
      _currentLog = PeriodModel(
        id: 'log_mock',
        userId: userId,
        startDate: DateTime.now().subtract(const Duration(days: 20)),
        cycleLength: 28,
        periodLength: 5,
        symptoms: ['Mệt nhẹ', 'Thèm ngọt 🍰'],
        mood: 'Vui vẻ',
        notifyPartner: true,
        createdAt: DateTime.now(),
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Ghi chép chu kỳ mới
  Future<void> logNewPeriod({
    required String userId,
    required DateTime startDate,
    int cycleLength = 28,
    int periodLength = 5,
    List<String> symptoms = const [],
    String? mood,
    bool notifyPartner = true,
  }) async {
    try {
      final res = await _supabase.from('period_logs').insert({
        'user_id': userId,
        'start_date': startDate.toIso8601String().split('T')[0],
        'cycle_length': cycleLength,
        'period_length': periodLength,
        'symptoms': symptoms,
        'mood': mood,
        'notify_partner': notifyPartner,
      }).select().single();

      _currentLog = PeriodModel.fromJson(res);
      notifyListeners();
    } catch (e) {
      debugPrint('Save Period Error: $e');
      _currentLog = PeriodModel(
        id: 'period_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        startDate: startDate,
        cycleLength: cycleLength,
        periodLength: periodLength,
        symptoms: symptoms,
        mood: mood,
        notifyPartner: notifyPartner,
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
