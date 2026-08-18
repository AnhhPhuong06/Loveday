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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.chatService.subscribeToMessages(widget.coupleId);
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    widget.chatService.sendMessage(
      coupleId: widget.coupleId,
      senderId: widget.currentUserId,
      text: text,
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161622),
        elevation: 1,
        title: Column(
          children: [
            Text(
              widget.partnerName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 3.5, backgroundColor: Color(0xFF00E676)),
                SizedBox(width: 4),
                Text(
                  'Đang online 💕',
                  style: TextStyle(fontSize: 11, color: Color(0xFF00E676)),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Real-time Chat Messages List with ListenableBuilder
          Expanded(
            child: ListenableBuilder(
              listenable: widget.chatService,
              builder: (context, _) {
                final messages = widget.chatService.messages;

                if (widget.chatService.isLoading && messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == widget.currentUserId || msg.senderId == 'me' || msg.senderId.startsWith('user');

                    if (msg.type == 'sticker') {
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(msg.text ?? '❤️', style: const TextStyle(fontSize: 44)),
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
                          color: isMe ? null : const Color(0xFF222232),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isMe ? AppColors.primary.withOpacity(0.3) : Colors.black26,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('HH:mm').format(msg.createdAt),
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Quick Love Stickers Bar
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF161622),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['❤️', '🥰', '😘', '🔥', '🌸', '🥺', '💍', '🍫', '🌹', '💌'].map((emoji) {
                return GestureDetector(
                  onTap: () => _sendLoveSticker(emoji),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.pink.withOpacity(0.2)),
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                  ),
                );
              }).toList(),
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF161622),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Nhắn lời yêu thương...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                        filled: true,
                        fillColor: const Color(0xFF222232),
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.loveGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
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
