import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/streak_service.dart';

class StreakCameraScreen extends StatefulWidget {
  final StreakService streakService;
  final String coupleId;
  final String currentUserId;

  const StreakCameraScreen({
    super.key,
    required this.streakService,
    required this.coupleId,
    required this.currentUserId,
  });

  @override
  State<StreakCameraScreen> createState() => _StreakCameraScreenState();
}

class _StreakCameraScreenState extends State<StreakCameraScreen> {
  final TextEditingController _captionController = TextEditingController();
  bool _isTakingPhoto = false;

  @override
  void initState() {
    super.initState();
    widget.streakService.loadStreaks(widget.coupleId);
  }

  Future<void> _handleSnapAndSend() async {
    setState(() => _isTakingPhoto = true);

    // Giả lập chụp ảnh từ camera và gửi
    await Future.delayed(const Duration(milliseconds: 600));
    await widget.streakService.sendStreakPhoto(
      coupleId: widget.coupleId,
      senderId: widget.currentUserId,
      photoUrl: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=800',
      caption: _captionController.text.isNotEmpty
          ? _captionController.text
          : 'Gửi ảnh giữ chuỗi hôm nay nè! 🔥📸',
    );

    _captionController.clear();
    setState(() => _isTakingPhoto = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.flameOrange,
          content: Text('🔥 Đã giữ chuỗi thành công! +1 ngày lửa mới!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final streaks = widget.streakService.recentStreaks;
    final currentStreak = widget.streakService.currentStreak;
    final hoursLeft = widget.streakService.hoursRemaining;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥 ', style: TextStyle(fontSize: 22)),
            Text(
              'Chuỗi $currentStreak Ngày',
              style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ],
        ),
        actions: [
          // Đồng hồ đếm ngược 24h nhắc chuỗi
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Còn ${hoursLeft}h',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Locket-style Camera Viewfinder & Snap Button
          Container(
            margin: const EdgeInsets.all(16),
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.flameOrange.withOpacity(0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Top Overlay
                Positioned(
                  top: 12,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Camera Trực Tiếp',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Snap Button
                Positioned(
                  bottom: 16,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _captionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Nhập lời nhắn kèm ảnh...',
                            hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.6),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _isTakingPhoto ? null : _handleSnapAndSend,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.flameGradient,
                          ),
                          child: Center(
                            child: _isTakingPhoto
                                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                : const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lịch sử ảnh chuỗi của 2 bạn (Locket/TikTok Feed)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Khoảnh khắc giữ chuỗi gần đây 🔥',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: streaks.length,
              itemBuilder: (context, index) {
                final item = streaks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E26),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network(
                          item.photoUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.caption ?? 'Giữ chuỗi ngày ${item.streakDayCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('HH:mm - dd/MM/yyyy').format(item.createdAt),
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: AppColors.flameGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '🔥 Ngày ${item.streakDayCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
