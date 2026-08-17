import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int numberOfParticles;
  final Color baseColor;

  const ParticleBackground({
    super.key,
    required this.child,
    this.numberOfParticles = 25,
    this.baseColor = const Color(0xFFFF4B72),
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_LoveParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(
      widget.numberOfParticles,
      (index) => _LoveParticle.random(_random, widget.baseColor),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ParticlePainter(_particles, _controller.value),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _LoveParticle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double oscillationSpeed;
  double oscillationDistance;
  Color color;
  bool isHeart;

  _LoveParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.oscillationSpeed,
    required this.oscillationDistance,
    required this.color,
    required this.isHeart,
  });

  factory _LoveParticle.random(Random random, Color baseColor) {
    final isHeart = random.nextBool();
    final colors = [
      baseColor.withOpacity(0.3 + random.nextDouble() * 0.4),
      const Color(0xFFFF758C).withOpacity(0.3 + random.nextDouble() * 0.4),
      const Color(0xFFFFB199).withOpacity(0.3 + random.nextDouble() * 0.4),
      Colors.white.withOpacity(0.2 + random.nextDouble() * 0.3),
    ];

    return _LoveParticle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: isHeart ? 10.0 + random.nextDouble() * 12.0 : 3.0 + random.nextDouble() * 5.0,
      speed: 0.0008 + random.nextDouble() * 0.0015,
      opacity: 0.3 + random.nextDouble() * 0.6,
      oscillationSpeed: 1.0 + random.nextDouble() * 3.0,
      oscillationDistance: 0.02 + random.nextDouble() * 0.04,
      color: colors[random.nextInt(colors.length)],
      isHeart: isHeart,
    );
  }

  void update() {
    y -= speed;
    if (y < -0.05) {
      y = 1.05;
      x = Random().nextDouble();
    }
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_LoveParticle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      p.update();

      final currentX = (p.x + sin(animationValue * 2 * pi * p.oscillationSpeed) * p.oscillationDistance) * size.width;
      final currentY = p.y * size.height;

      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      if (p.isHeart) {
        _drawHeart(canvas, Offset(currentX, currentY), p.size, paint);
      } else {
        // Star sparkle
        canvas.drawCircle(Offset(currentX, currentY), p.size / 2, paint);
      }
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final width = size;
    final height = size;

    path.moveTo(center.dx, center.dy + height / 4);
    path.cubicTo(
      center.dx + width / 2, center.dy - height / 2,
      center.dx + width, center.dy + height / 3,
      center.dx, center.dy + height,
    );
    path.moveTo(center.dx, center.dy + height / 4);
    path.cubicTo(
      center.dx - width / 2, center.dy - height / 2,
      center.dx - width, center.dy + height / 3,
      center.dx, center.dy + height,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
