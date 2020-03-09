import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class TilePainter extends CustomPainter {

  final bool mirrored;

  const TilePainter({
    this.mirrored = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = min(size.width /2, size.height /2);
    final circleDx = radius;
    final circleDy = radius;
    final Gradient gradient = const LinearGradient(
      colors: const <Color>[
        Colors.green,
        Colors.green,
        Colors.yellow,
        Colors.red,
        Colors.red,
      ],
      stops: const [0.0, 0.1, 0.4, 0.9, 1.0],
    );

    final rect = Rect.fromCircle(
      center: Offset(circleDx, circleDy),
      radius: radius,
    );

    if (mirrored) {
      //flip canvas
      canvas.transform(
        (Matrix4.identity()
              ..translate(width, 0.0, 0.0)
              ..rotateY(3.14))
            .storage,
      );
    }

    final path = Path()
      ..addOval(rect)
      ..lineTo(radius * 2, size.height)
      ..lineTo(width, height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = height /20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
