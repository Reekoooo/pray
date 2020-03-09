import 'dart:math';

import 'package:flutter/material.dart';

class BackGroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    print("Doing expensive paint job");
    Random rand = new Random(12345);
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.white,
    ];
    for (int i = 0; i < 5000; i++) {
      canvas.drawCircle(
          Offset(
              rand.nextDouble() * size.width, rand.nextDouble() * size.height),
          10 + rand.nextDouble() * 20,
          Paint()
            ..color = colors[rand.nextInt(colors.length)].withOpacity(0.1));
    }
  }

  @override
  bool shouldRepaint(BackGroundPainter other) => false;
}