import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/chat_service.dart';

class CoupleChatScreen extends StatefulWidget {
  final ChatService chatService;
  final String coupleId;
  final String currentUserId;
  final String partnerName;

  const CoupleChatScreen({
    super.key,
    required this.chatService,
    required this.coupleId,
    required this.currentUserId,
    required this.partnerName,
  });

  @override
  State<CoupleChatScreen> createState() => _CoupleChatScreenState();
}

class _CoupleChatScreenState extends State<CoupleChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.chatService.subscribeToMessages(widget.coupleId);
  }

  void _handleSend() {
    if (_textController.text.trim().isEmpty) return;
    widget.chatService.sendMessage(
      coupleId: widget.coupleId,
      senderId: widget.currentUserId,
      text: _textController.text.trim(),
    );
    _textController.clear();
  }

  void _sendLoveSticker(String sticker) {
    widget.chatService.sendMessage(
      coupleId: widget.coupleId,
      senderId: widget.currentUserId,
      text: sticker,
      type: 'sticker',
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.chatService.messages;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.partnerName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 3, backgroundColor: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Đang online 💕',
                  style: TextStyle(fontSize: 11, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.senderId == widget.currentUserId || msg.senderId == 'me';

                if (msg.type == 'sticker') {
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(msg.text ?? '❤️', style: const TextStyle(fontSize: 40)),
                    ),
                  );
                }

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      gradient: isMe ? AppColors.loveGradient : null,
                      color: isMe ? null : const Color(0xFFE9E9F0),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(isMe ? 18 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text ?? '',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(msg.createdAt),
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black45,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Love Stickers Bar
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['❤️', '🥰', '😘', '🔥', '🌸', '🥺', '💍', '🍫'].map((emoji) {
                return GestureDetector(
                  onTap: () => _sendLoveSticker(emoji),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
                  ),
                );
              }).toList(),
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Nhắn lời yêu thương...',
                        filled: true,
                        fillColor: const Color(0xFFF2F2F7),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _handleSend,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
