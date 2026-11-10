import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Brand mark built in Flutter (no generated image assets).
class AgriWheelLogo extends StatelessWidget {
  const AgriWheelLogo({
    super.key,
    required this.size,
    this.wheelColor = AppColors.white,
    this.accentColor = AppColors.yellow,
  });

  final double size;
  final Color wheelColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final ring = size;
    final inner = size * 0.72;

    return SizedBox(
      width: ring,
      height: ring,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: ring,
            height: ring,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: wheelColor, width: size * 0.06),
            ),
          ),
          CustomPaint(
            size: Size(inner, inner),
            painter: _WheelSpokesPainter(color: wheelColor, stroke: size * 0.045),
          ),
          Icon(Icons.agriculture, size: size * 0.34, color: accentColor),
        ],
      ),
    );
  }
}

class _WheelSpokesPainter extends CustomPainter {
  _WheelSpokesPainter({required this.color, required this.stroke});

  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    canvas.drawCircle(center, r, paint);
    for (var i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      final dx = center.dx + r * 0.92 * math.cos(angle);
      final dy = center.dy + r * 0.92 * math.sin(angle);
      canvas.drawLine(center, Offset(dx, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
