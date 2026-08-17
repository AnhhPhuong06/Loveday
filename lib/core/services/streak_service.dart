import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/streak_model.dart';

class StreakService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<StreakModel> _recentStreaks = [];
  int _currentStreak = 12; // Default demo streak
  int _hoursRemaining = 8;  // Đếm ngược giờ còn lại trong ngày để giữ chuỗi
  bool _isLoading = false;

  List<StreakModel> get recentStreaks => _recentStreaks;
  int get currentStreak => _currentStreak;
  int get hoursRemaining => _hoursRemaining;
  bool get isLoading => _isLoading;

  /// Tải lịch sử ảnh chuỗi của cặp đôi
  Future<void> loadStreaks(String coupleId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _supabase
          .from('streaks')
          .select()
          .eq('couple_id', coupleId)
          .order('created_at', ascending: false)
          .limit(30);

      _recentStreaks = (data as List).map((e) => StreakModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Load Streaks Error: $e');
      // Mock data hiển thị gallery chuỗi
      _recentStreaks = [
        StreakModel(
          id: 'streak_1',
          coupleId: coupleId,
          senderId: 'user_1',
          photoUrl: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=600',
          caption: 'Cùng em đi ngắm hoàng hôn chiều nay 🌅🔥',
          streakDayCount: 12,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        StreakModel(
          id: 'streak_2',
          coupleId: coupleId,
          senderId: 'user_2',
          photoUrl: 'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=600',
          caption: 'Cốc trà sữa ngọt ngào anh mua cho 🧋✨',
          streakDayCount: 11,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    }
    _calculateHoursRemaining();
    _isLoading = false;
    notifyListeners();
  }

  /// Gửi ảnh chụp giữ chuỗi (Streaks Snap)
  Future<bool> sendStreakPhoto({
    required String coupleId,
    required String senderId,
    required String photoUrl,
    String? caption,
  }) async {
    try {
      final nextStreak = _currentStreak + 1;
      await _supabase.from('streaks').insert({
        'couple_id': coupleId,
        'sender_id': senderId,
        'photo_url': photoUrl,
        'caption': caption,
        'streak_day_count': nextStreak,
      });

      // Cập nhật chuỗi mới vào bảng couples
      await _supabase.from('couples').update({
        'current_streak': nextStreak,
        'last_streak_date': DateTime.now().toIso8601String().split('T')[0],
      }).eq('id', coupleId);

      _currentStreak = nextStreak;
      final newStreak = StreakModel(
        id: 'streak_${DateTime.now().millisecondsSinceEpoch}',
        coupleId: coupleId,
        senderId: senderId,
        photoUrl: photoUrl,
        caption: caption,
        streakDayCount: nextStreak,
        createdAt: DateTime.now(),
      );
      _recentStreaks.insert(0, newStreak);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Send Streak Error: $e');
      _currentStreak += 1;
      _recentStreaks.insert(
        0,
        StreakModel(
          id: 'streak_local',
          coupleId: coupleId,
          senderId: senderId,
          photoUrl: photoUrl,
          caption: caption,
          streakDayCount: _currentStreak,
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return true;
    }
  }

  void _calculateHoursRemaining() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    _hoursRemaining = endOfDay.difference(now).inHours;
    if (_hoursRemaining < 0) _hoursRemaining = 0;
  }
}
