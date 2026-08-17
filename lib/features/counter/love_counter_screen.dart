import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/couple_service.dart';
import '../../widgets/heart_pulse_widget.dart';
import '../../widgets/streak_badge.dart';
import '../../widgets/particle_background.dart';
import '../../widgets/glowing_avatar.dart';
import '../settings/widget_customizer_screen.dart';

class LoveCounterScreen extends StatefulWidget {
  final AuthService authService;
  final CoupleService coupleService;
  final VoidCallback onOpenStreaks;

  const LoveCounterScreen({
    super.key,
    required this.authService,
    required this.coupleService,
    required this.onOpenStreaks,
  });

  @override
  State<LoveCounterScreen> createState() => _LoveCounterScreenState();
}

class _LoveCounterScreenState extends State<LoveCounterScreen> {
  String _myName = 'Anh Yêu 👦';
  String _partnerName = 'Em Yêu 👧';
  String? _myCustomAvatar;
  String? _partnerCustomAvatar;
  Color _myFrameColor = const Color(0xFFFF4B72);
  Color _partnerFrameColor = const Color(0xFFFFB800);

  @override
  void initState() {
    super.initState();
    _myName = widget.authService.currentUser?.displayName ?? 'Anh Yêu 👦';
    _partnerName = widget.coupleService.partner?.displayName ?? 'Em Yêu 👧';
  }

  @override
  Widget build(BuildContext context) {
    final couple = widget.coupleService.couple;
    final totalDays = couple?.totalLoveDays ?? 128;
    final streak = couple?.currentStreak ?? 12;

    return Scaffold(
      body: Stack(
        children: [
          // Background Romantic Cover Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/couple_cover_bg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.network(
                couple?.coverImageUrl ??
                    'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=1200',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Gradient Glassmorphism Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.black.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 60FPS Floating Romantic Hearts & Sparkles Canvas
          const Positioned.fill(
            child: ParticleBackground(
              numberOfParticles: 30,
              baseColor: Color(0xFFFF4B72),
              child: SizedBox.expand(),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  // Top Header: App Title, Widget Studio Shortcut & Streak Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LoveDay 💕',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Bên nhau trọn từng khoảnh khắc',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Widget Studio Button
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.widgets_outlined, color: Colors.white, size: 22),
                            tooltip: 'Tùy chỉnh Khung Viền Widget',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WidgetCustomizerScreen(
                                    daysTogether: totalDays,
                                    myName: _myName,
                                    partnerName: _partnerName,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          StreakBadge(
                            count: streak,
                            isCompletedToday: couple?.isStreakCompletedToday ?? true,
                            onTap: widget.onOpenStreaks,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Interactive Couple Avatars with Customizable Glowing Frames
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User Avatar Frame
                      GlowingAvatarFrame(
                        name: _myName,
                        role: 'boy',
                        avatarAsset: 'assets/images/avatar_boy.png',
                        customImagePath: _myCustomAvatar,
                        fallbackUrl: widget.authService.currentUser?.avatarUrl ?? '',
                        frameColor: _myFrameColor,
                        onUpdate: (newName, newPath, newColor) {
                          setState(() {
                            _myName = newName;
                            if (newPath != null) _myCustomAvatar = newPath;
                            _myFrameColor = newColor;
                          });
                        },
                      ),

                      const SizedBox(width: 14),

                      // Pulsing Neon Heart Connector
                      Column(
                        children: [
                          HeartPulseWidget(size: 60, color: _myFrameColor),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('Forever', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // Partner Avatar Frame
                      GlowingAvatarFrame(
                        name: _partnerName,
                        role: 'girl',
                        avatarAsset: 'assets/images/avatar_girl.png',
                        customImagePath: _partnerCustomAvatar,
                        fallbackUrl: widget.coupleService.partner?.avatarUrl ?? '',
                        frameColor: _partnerFrameColor,
                        onUpdate: (newName, newPath, newColor) {
                          setState(() {
                            _partnerName = newName;
                            if (newPath != null) _partnerCustomAvatar = newPath;
                            _partnerFrameColor = newColor;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Large Love Days Counter (InLove Aesthetic Glass Card)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: _myFrameColor.withOpacity(0.35), width: 1.8),
                      boxShadow: [
                        BoxShadow(
                          color: _myFrameColor.withOpacity(0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CHÚNG MÌNH ĐÃ YÊU NHAU',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$totalDays',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 68,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(color: Colors.pinkAccent, blurRadius: 20),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'NGÀY',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${totalDays * 24} giờ • ${totalDays * 1440} phút • ${totalDays * 86400} giây',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Upcoming Anniversary Milestone & Progress Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WidgetCustomizerScreen(
                            daysTogether: totalDays,
                            myName: _myName,
                            partnerName: _partnerName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('🎉', style: TextStyle(fontSize: 18)),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cột mốc tiếp theo: 200 ngày',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Còn ${200 - (totalDays % 200)} ngày nữa • Nhấn để sửa Widget',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
