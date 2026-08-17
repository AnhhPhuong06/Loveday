import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StreakBadge extends StatelessWidget {
  final int count;
  final bool isCompletedToday;
  final VoidCallback? onTap;

  const StreakBadge({
    super.key,
    required this.count,
    this.isCompletedToday = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isCompletedToday
              ? AppColors.flameGradient
              : const LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isCompletedToday
              ? [
                  BoxShadow(
                    color: AppColors.flameOrange.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🔥',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'NGÀY',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
