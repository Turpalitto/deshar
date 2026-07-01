import 'package:flutter/material.dart';
import '../tokens/app_spacing.dart';
import '../tokens/nokhchiin_colors.dart';

/// Тонкий декоративный орнамент под заголовком.
class OrnamentAccent extends StatelessWidget {
  const OrnamentAccent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.sm,
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 6),
        painter: _OrnamentPainter(
          color: NokhchiinColors.ornament.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}

class _OrnamentPainter extends CustomPainter {
  _OrnamentPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;
    final w = size.width;
    final path = Path()
      ..moveTo(0, y)
      ..quadraticBezierTo(w * 0.25, y - 4, w * 0.5, y)
      ..quadraticBezierTo(w * 0.75, y + 4, w, y);
    canvas.drawPath(path, paint);

    final dot = Paint()..color = color;
    canvas.drawCircle(Offset(w * 0.5, y), 3, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
