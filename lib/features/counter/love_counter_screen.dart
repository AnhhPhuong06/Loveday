import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/couple_service.dart';
import '../../widgets/heart_pulse_widget.dart';
import '../../widgets/streak_badge.dart';

class LoveCounterScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final couple = coupleService.couple;
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

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.75),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  // Top Header: App Title & Streak Badge
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
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Bên nhau mỗi ngày',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      StreakBadge(
                        count: streak,
                        isCompletedToday: couple?.isStreakCompletedToday ?? true,
                        onTap: onOpenStreaks,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Couple Avatars & Heart Pulse Connector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User Avatar
                      _CoupleAvatar(
                        name: authService.currentUser?.displayName ?? 'Anh Yêu',
                        avatarAsset: 'assets/images/avatar_boy.png',
                        fallbackUrl: authService.currentUser?.avatarUrl ??
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
                      ),
                      const SizedBox(width: 16),

                      // Animated Pulsing Heart
                      const HeartPulseWidget(size: 64),

                      const SizedBox(width: 16),
                      // Partner Avatar
                      _CoupleAvatar(
                        name: coupleService.partner?.displayName ?? 'Em Yêu',
                        avatarAsset: 'assets/images/avatar_girl.png',
                        fallbackUrl: coupleService.partner?.avatarUrl ??
                            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Large Love Days Counter (InLove Style)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CHÚNG MÌNH ĐÃ YÊU NHAU',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$totalDays',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'NGÀY',
                              style: TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${totalDays * 24} giờ • ${totalDays * 1440} phút',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Upcoming Anniversary Milestone
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
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
                                Text(
                                  'Còn ${200 - (totalDays % 200)} ngày nữa',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                      ],
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

class _CoupleAvatar extends StatelessWidget {
  final String name;
  final String avatarAsset;
  final String fallbackUrl;

  const _CoupleAvatar({
    required this.name,
    required this.avatarAsset,
    required this.fallbackUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.loveGradient,
          ),
          child: CircleAvatar(
            radius: 38,
            backgroundColor: Colors.pink[50],
            backgroundImage: AssetImage(avatarAsset) as ImageProvider,
            onBackgroundImageError: (_, __) {},
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
