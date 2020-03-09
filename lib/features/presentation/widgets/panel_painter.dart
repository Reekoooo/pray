import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class PanelPainter extends CustomPainter {
  final bool mirrored;
  final String text;
  final TextStyle textStyle;
  final bool autoAnimateText;
  final double scalingFactor;

  const PanelPainter({
    this.text = '',
    this.textStyle = const TextStyle(
      color: Colors.red,
    ),
    this.mirrored,
    this.autoAnimateText = true,
    this.scalingFactor = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final width = size.width;
    final height = size.height;
    final radius = min(size.width / 2, size.height / 2);
    final circleDx = radius;
    final circleDy = radius;
    final fontSize = min(width * scalingFactor, height * scalingFactor)
        .clamp(0.0, min(height / 1.5, width / 1.5));

    final Gradient gradient = const LinearGradient(
      colors: const <Color>[
        Colors.green,
        Colors.green,
        Colors.yellow,
        Colors.red,
        Colors.red,
      ],
      stops: const [
        0.0,
        0.1,
        0.4,
        0.9,
        1.0,
      ],
    );

    final rect = Rect.fromCircle(
      center: Offset(circleDx, circleDy),
      radius: radius,
    );

    canvas.save();

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
      ..strokeWidth = height / 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: autoAnimateText
            ? textStyle.copyWith(fontSize: fontSize)
            : textStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    canvas.restore();

    canvas.save();

    if (!mirrored) {
      canvas.translate(width - textPainter.size.width, 0.0);
    }

    textPainter.paint(canvas, Offset(5.0, 0));

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

