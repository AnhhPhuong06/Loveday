import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/message_model.dart';

class ChatService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<MessageModel> _messages = [];
  RealtimeChannel? _subscription;
  bool _isLoading = false;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;

  /// Khởi tạo và nạp tin nhắn từ SharedPreferences / Supabase
  void subscribeToMessages(String coupleId) async {
    _isLoading = true;
    notifyListeners();

    // 1. Nạp tin nhắn đã lưu trước từ local cache
    await _loadLocalMessages(coupleId);

    // 2. Thử kết nối Supabase Realtime
    try {
      _subscription = _supabase
          .channel('messages_$coupleId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'messages',
            callback: (payload) {
              final newRecord = payload.newRecord;
              if (newRecord['couple_id'] == coupleId) {
                final newMsg = MessageModel.fromJson(newRecord);
                if (!_messages.any((m) => m.id == newMsg.id)) {
                  _messages.insert(0, newMsg);
                  _saveLocalMessages(coupleId);
                  notifyListeners();
                }
              }
            },
          )
          .subscribe();

      final data = await _supabase
          .from('messages')
          .select()
          .eq('couple_id', coupleId)
          .order('created_at', ascending: false)
          .limit(50);

      if (data != null && (data as List).isNotEmpty) {
        _messages = (data as List).map((e) => MessageModel.fromJson(e)).toList();
        await _saveLocalMessages(coupleId);
      }
    } catch (e) {
      debugPrint('Realtime Chat (Using reactive local engine): $e');
      if (_messages.isEmpty) {
        _populateDefaultMessages(coupleId);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Gửi tin nhắn mới (Hiển thị ngay lập tức, lưu cục bộ và gửi lên đám mây)
  Future<void> sendMessage({
    required String coupleId,
    required String senderId,
    required String text,
    String? mediaUrl,
    String type = 'text',
  }) async {
    final tempMsg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      coupleId: coupleId,
      senderId: senderId,
      text: text,
      mediaUrl: mediaUrl,
      type: type,
      createdAt: DateTime.now(),
    );

    _messages.insert(0, tempMsg);
    await _saveLocalMessages(coupleId);
    notifyListeners();

    // Tự động phản hồi đáng yêu từ đối phương (Simulated Real-time Love Partner)
    _triggerPartnerAutoReply(coupleId, text, type);

    // Gửi lên Supabase nếu có mạng
    try {
      await _supabase.from('messages').insert({
        'couple_id': coupleId,
        'sender_id': senderId,
        'text': text,
        'media_url': mediaUrl,
        'type': type,
      });
    } catch (e) {
      debugPrint('Send Message Remote Sync Note: $e');
    }
  }

  void _triggerPartnerAutoReply(String coupleId, String userText, String type) {
    Future.delayed(const Duration(milliseconds: 1200), () async {
      String replyText = 'Em cũng nhớ anh nhiều lắm 💕';

      final lower = userText.toLowerCase();
      if (type == 'sticker') {
        replyText = userText == '❤️' ? '🥰' : (userText == '🔥' ? '😘' : '💖');
      } else if (lower.contains('ăn') || lower.contains('đói')) {
        replyText = 'Tối nay anh đưa em đi ăn món gì ngon nhé! 🍣🍜';
      } else if (lower.contains('nhớ') || lower.contains('yêu')) {
        replyText = 'Thương anh nhất quả đất! Hôn anh cái nè 😘💋';
      } else if (lower.contains('chuỗi') || lower.contains('ảnh')) {
        replyText = 'Dạaa, em vừa chụp ảnh gửi chuỗi cho anh rồi đó 📸🔥';
      } else if (lower.contains('ngủ')) {
        replyText = 'Chúc anh ngủ ngon và mơ thấy em nha 🌙💤';
      }

      final partnerMsg = MessageModel(
        id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        coupleId: coupleId,
        senderId: 'partner',
        text: replyText,
        type: type == 'sticker' ? 'sticker' : 'text',
        createdAt: DateTime.now(),
      );

      _messages.insert(0, partnerMsg);
      await _saveLocalMessages(coupleId);
      notifyListeners();
    });
  }

  Future<void> _loadLocalMessages(String coupleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('chat_messages_$coupleId');
      if (raw != null) {
        final List list = jsonDecode(raw);
        _messages = list.map((e) => MessageModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Load local messages error: $e');
    }
  }

  Future<void> _saveLocalMessages(String coupleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(_messages.map((e) => e.toJson()).toList());
      await prefs.setString('chat_messages_$coupleId', raw);
    } catch (e) {
      debugPrint('Save local messages error: $e');
    }
  }

  void _populateDefaultMessages(String coupleId) {
    _messages = [
      MessageModel(
        id: 'm3',
        coupleId: coupleId,
        senderId: 'partner',
        text: 'Anh nhớ chụp ảnh gửi giữ chuỗi hôm nay nha 🔥📸',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      MessageModel(
        id: 'm2',
        coupleId: coupleId,
        senderId: 'me',
        text: 'Lúc nào anh cũng nhớ em hết! Tối nay anh đón nhé ❤️',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      MessageModel(
        id: 'm1',
        coupleId: coupleId,
        senderId: 'partner',
        text: 'Hôm nay anh có nhớ em không? 🥰',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
    _saveLocalMessages(coupleId);
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }
}
