import 'package:flutter/material.dart';

class HexagonPainter extends CustomPainter {
  final Color color;

  HexagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    double width = size.width;
    double height = size.height;

    // Calculate the vertical stretch
    double verticalStretch = 0.3; // Adjust this value to stretch vertically more or less

    // Define hexagon points with vertical stretch
    path.moveTo(width * 0.5, 0);                         // Top center
    path.lineTo(width, height * (0.5 - verticalStretch)); // Top right
    path.lineTo(width, height * (0.5 + verticalStretch)); // Bottom right
    path.lineTo(width * 0.5, height);                    // Bottom center
    path.lineTo(0, height * (0.5 + verticalStretch));    // Bottom left
    path.lineTo(0, height * (0.5 - verticalStretch));    // Top left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
