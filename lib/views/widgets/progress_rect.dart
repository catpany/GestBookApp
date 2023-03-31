import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/views/styles.dart';

class ProgressRect extends CustomPainter {
  final double progress;

  ProgressRect(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 10;
    List<List<double>> coordinates = [
      [radius, 0],
      [size.width - radius, 0],
      [size.width, radius],
      [size.width, size.height - radius],
      [size.width - radius, size.height],
      [radius, size.height],
      [0, size.height - radius],
      [0, radius],
      [radius, 0]
    ];

    double perimeter = (size.width + size.height) * 2;
    double progressLength = perimeter * progress;
    int sideCount = progressLength ~/ size.width;
    double ost = progressLength - size.width * sideCount;
    int side = 1;

    Path path = Path();
    path.moveTo(coordinates[0][0], coordinates[0][1]);
    for (side = 1; side <= sideCount * 2; side += 2) {
      path.lineTo(coordinates[side][0], coordinates[side][1]);
      path.arcToPoint(
          Offset(coordinates[side + 1][0], coordinates[side + 1][1]), radius: Radius.circular(radius));
    }

    if (ost > 0 && side < 9) {
      List<double> newCoordinates =
          calculateCoordinates(side, size, radius, ost);
      path.lineTo(newCoordinates[0], newCoordinates[1]);
    } else if (9 == side) {
      path.arcToPoint(Offset(coordinates[8][0], coordinates[8][1]));
      path.close();
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 6.0
        ..color = ColorStyles.yellow,
    );
  }

  List<double> calculateCoordinates(
      int side, Size size, double radius, double ost) {
    switch (side) {
      case 1:
        return [ost, 0];
      case 3:
        return [size.width, ost];
      case 5:
        return [size.width - ost, size.height];
      default:
        return [0, size.height - ost];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
