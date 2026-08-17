import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/message_model.dart';

class ChatService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<MessageModel> _messages = [];
  RealtimeChannel? _subscription;
  bool _isLoading = false;

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;

  /// Bắt đầu lắng nghe tin nhắn Realtime qua WebSocket Supabase
  void subscribeToMessages(String coupleId) {
    _isLoading = true;
    notifyListeners();

    try {
      _subscription = _supabase.channel('public:messages:couple_$coupleId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'couple_id',
              value: coupleId,
            ),
            callback: (payload) {
              final newMsg = MessageModel.fromJson(payload.newRecord);
              _messages.insert(0, newMsg);
              notifyListeners();
            },
          )
          .subscribe();

      _loadInitialMessages(coupleId);
    } catch (e) {
      debugPrint('Realtime Chat Error: $e');
      _populateMockMessages(coupleId);
    }
  }

  Future<void> _loadInitialMessages(String coupleId) async {
    try {
      final data = await _supabase
          .from('messages')
          .select()
          .eq('couple_id', coupleId)
          .order('created_at', ascending: false)
          .limit(50);

      _messages = (data as List).map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      _populateMockMessages(coupleId);
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Gửi tin nhắn mới (Text, Ảnh, Sticker, Voice)
  Future<void> sendMessage({
    required String coupleId,
    required String senderId,
    required String text,
    String? mediaUrl,
    String type = 'text',
  }) async {
    final tempMsg = MessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      coupleId: coupleId,
      senderId: senderId,
      text: text,
      mediaUrl: mediaUrl,
      type: type,
      createdAt: DateTime.now(),
    );

    _messages.insert(0, tempMsg);
    notifyListeners();

    try {
      await _supabase.from('messages').insert({
        'couple_id': coupleId,
        'sender_id': senderId,
        'text': text,
        'media_url': mediaUrl,
        'type': type,
      });
    } catch (e) {
      debugPrint('Send Message Server Error: $e');
    }
  }

  void _populateMockMessages(String coupleId) {
    _messages = [
      MessageModel(
        id: 'm1',
        coupleId: coupleId,
        senderId: 'partner',
        text: 'Hôm nay anh có nhớ em không? 🥰',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: 'm2',
        coupleId: coupleId,
        senderId: 'me',
        text: 'Lúc nào anh cũng nhớ em hết! Tối nay anh đón em đi ăn nhé ❤️',
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      MessageModel(
        id: 'm3',
        coupleId: coupleId,
        senderId: 'partner',
        text: 'Dạaaa, anh nhớ giữ chuỗi ảnh hôm nay nữa nha 🔥📸',
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
    _isLoading = false;
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }
}
