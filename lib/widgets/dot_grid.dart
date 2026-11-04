import 'package:flutter/material.dart';

/// Grade de pontos do fundo, com fade em direção ao rodapé.
class DotGridPainter extends CustomPainter {
  const DotGridPainter();

  static const double spacing = 24;
  static const double dotRadius = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (double y = spacing / 2; y < size.height; y += spacing) {
      final double fade = (1 - (y / size.height) * 0.65).clamp(0.0, 1.0);
      paint.color = Color.fromRGBO(255, 255, 255, 0.06 * fade);

      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
