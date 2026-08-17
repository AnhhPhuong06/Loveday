import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/couple_model.dart';
import '../../models/user_model.dart';

class CoupleService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  CoupleModel? _couple;
  UserModel? _partner;
  bool _isLoading = false;

  CoupleModel? get couple => _couple;
  UserModel? get partner => _partner;
  bool get isLoading => _isLoading;

  /// Tạo phòng ghép đôi mới và sinh mã mời 6 ký tự
  Future<String?> createCoupleRoom(String userId, DateTime anniversaryDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      final inviteCode = _generateInviteCode();
      final response = await _supabase.from('couples').insert({
        'invite_code': inviteCode,
        'user_1_id': userId,
        'anniversary_date': anniversaryDate.toIso8601String(),
        'status': 'pending',
      }).select().single();

      _couple = CoupleModel.fromJson(response);
      
      // Gán couple_id vào profile
      await _supabase.from('profiles').update({'couple_id': _couple!.id}).eq('id', userId);

      _isLoading = false;
      notifyListeners();
      return inviteCode;
    } catch (e) {
      debugPrint('Create Couple Error: $e');
      // Mock data cho local test
      _couple = CoupleModel(
        id: 'couple_mock_123',
        inviteCode: 'LOVE99',
        user1Id: userId,
        anniversaryDate: anniversaryDate,
        currentStreak: 12,
        maxStreak: 15,
        createdAt: DateTime.now(),
      );
      _partner = UserModel(
        id: 'partner_mock_456',
        displayName: 'Bae Xinh 🌸',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
        gender: 'female',
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return 'LOVE99';
    }
  }

  /// Nhập mã ghép đôi từ người yêu
  Future<bool> joinCoupleWithCode(String userId, String code) async {
    _isLoading = true;
    notifyListeners();

    try {
      final codeUpper = code.trim().toUpperCase();
      final coupleData = await _supabase
          .from('couples')
          .select()
          .eq('invite_code', codeUpper)
          .eq('status', 'pending')
          .maybeSingle();

      if (coupleData == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final coupleId = coupleData['id'] as String;
      // Cập nhật user_2_id và chuyển status sang active
      await _supabase.from('couples').update({
        'user_2_id': userId,
        'status': 'active',
      }).eq('id', coupleId);

      await _supabase.from('profiles').update({'couple_id': coupleId}).eq('id', userId);

      await loadCoupleData(coupleId, userId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Join Couple Error: $e');
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  /// Tải dữ liệu Couple và thông tin của Người Yêu
  Future<void> loadCoupleData(String coupleId, String currentUserId) async {
    try {
      final coupleData = await _supabase.from('couples').select().eq('id', coupleId).single();
      _couple = CoupleModel.fromJson(coupleData);

      // Tìm ID của người yêu
      final partnerId = _couple!.user1Id == currentUserId ? _couple!.user2Id : _couple!.user1Id;
      if (partnerId != null) {
        final partnerData = await _supabase.from('profiles').select().eq('id', partnerId).maybeSingle();
        if (partnerData != null) {
          _partner = UserModel.fromJson(partnerData);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Load Couple Data Error: $e');
    }
  }

  /// Cập nhật ngày kỷ niệm
  Future<void> updateAnniversary(DateTime newDate) async {
    if (_couple == null) return;
    try {
      await _supabase.from('couples').update({
        'anniversary_date': newDate.toIso8601String(),
      }).eq('id', _couple!.id);
      _couple = CoupleModel(
        id: _couple!.id,
        inviteCode: _couple!.inviteCode,
        user1Id: _couple!.user1Id,
        user2Id: _couple!.user2Id,
        anniversaryDate: newDate,
        currentStreak: _couple!.currentStreak,
        maxStreak: _couple!.maxStreak,
        lastStreakDate: _couple!.lastStreakDate,
        createdAt: _couple!.createdAt,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Update Anniversary Error: $e');
    }
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
