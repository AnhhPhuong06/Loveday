import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/couple_service.dart';
import '../../core/services/streak_service.dart';
import '../../core/services/period_service.dart';
import '../../core/services/chat_service.dart';
import '../../core/services/dynamic_icon_service.dart';
import 'counter/love_counter_screen.dart';
import 'streaks/streak_camera_screen.dart';
import 'period/period_tracker_screen.dart';
import 'chat/couple_chat_screen.dart';
import 'memories/memories_timeline_screen.dart';
import 'settings/dynamic_icon_screen.dart';

class HomeShellScreen extends StatefulWidget {
  final AuthService authService;
  final CoupleService coupleService;

  const HomeShellScreen({
    super.key,
    required this.authService,
    required this.coupleService,
  });

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;
  final StreakService _streakService = StreakService();
  final PeriodService _periodService = PeriodService();
  final ChatService _chatService = ChatService();
  final DynamicIconService _dynamicIconService = DynamicIconService();

  @override
  Widget build(BuildContext context) {
    final coupleId = widget.coupleService.couple?.id ?? 'couple_demo';
    final currentUserId = widget.authService.currentUser?.id ?? 'user_me';
    final partnerName = widget.coupleService.partner?.displayName ?? 'Người yêu 💕';

    final List<Widget> screens = [
      LoveCounterScreen(
        authService: widget.authService,
        coupleService: widget.coupleService,
        onOpenStreaks: () => setState(() => _currentIndex = 1),
      ),
      StreakCameraScreen(
        streakService: _streakService,
        coupleId: coupleId,
        currentUserId: currentUserId,
      ),
      PeriodTrackerScreen(
        periodService: _periodService,
        userId: currentUserId,
      ),
      CoupleChatScreen(
        chatService: _chatService,
        coupleId: coupleId,
        currentUserId: currentUserId,
        partnerName: partnerName,
      ),
      MemoriesTimelineScreen(coupleId: coupleId),
      DynamicIconScreen(
        dynamicIconService: _dynamicIconService,
        userStreak: widget.coupleService.couple?.currentStreak ?? 12,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.favorite_rounded,
                  label: 'Đếm Ngày',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Chuỗi 🔥',
                  isSelected: _currentIndex == 1,
                  activeColor: AppColors.flameOrange,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.water_drop_rounded,
                  label: 'Chu Kỳ',
                  isSelected: _currentIndex == 2,
                  activeColor: AppColors.periodFlow,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _NavItem(
                  icon: Icons.chat_bubble_rounded,
                  label: 'Nhắn Tin',
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
                _NavItem(
                  icon: Icons.photo_library_rounded,
                  label: 'Kỷ Niệm',
                  isSelected: _currentIndex == 4,
                  onTap: () => setState(() => _currentIndex = 4),
                ),
                _NavItem(
                  icon: Icons.palette_rounded,
                  label: 'Đổi Icon',
                  isSelected: _currentIndex == 5,
                  onTap: () => setState(() => _currentIndex = 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.activeColor = AppColors.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : Colors.grey[500],
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
