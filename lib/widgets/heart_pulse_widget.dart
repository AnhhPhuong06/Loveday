import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class HeartPulseWidget extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;
  final Color? color;

  const HeartPulseWidget({
    super.key,
    this.size = 80.0,
    this.onTap,
    this.color,
  });

  @override
  State<HeartPulseWidget> createState() => _HeartPulseWidgetState();
}

class _HeartPulseWidgetState extends State<HeartPulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? AppColors.primary;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color != null ? activeColor : null,
                gradient: widget.color == null ? AppColors.loveGradient : null,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.55),
                    blurRadius: 16,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: widget.size * 0.55,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
