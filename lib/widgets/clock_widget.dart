import 'dart:math';

import 'package:alarm_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClockWidget extends StatelessWidget {
  final dateTime;
  final bool isSecondsVisible;
  final double size;

  const ClockWidget({Key? key, @required this.dateTime, this.isSecondsVisible = true, this.size = 250});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockPainter(dateTime, isSecondVisible: isSecondsVisible),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime _dateTime;
  final bool isSecondVisible;

  _ClockPainter(this._dateTime, {required this.isSecondVisible});

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerY, centerY);
    var radius = min(centerX, centerY);
    var fillBrush = Paint()
      ..color = AppColors.gunMetal;
    var outlineBrush = Paint()
      ..color = AppColors.lavender
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 20;
    var centerFillBrush = Paint()
      ..color = AppColors.lavender;
    var secHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 60;
    var minHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [AppColors.cornflowerBlue, AppColors.paleCyan])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 30;
    var hourHandBrush = Paint()
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [AppColors.cyclamen, AppColors.vividMulberry])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 24;
    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    var hourMoveCount = (_dateTime.hour * 30 + _dateTime.minute * 0.5) * pi / 180;
    var hourHandX = centerX + radius * 0.45 * sin(hourMoveCount);
    var hourHandY = centerY + radius * 0.45 * -cos(hourMoveCount);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minMoveCount = _dateTime.minute * 6 * pi / 180;
    var minHandX = centerX + radius * 0.6 * sin(minMoveCount);
    var minHandY = centerY + radius * 0.6 * -cos(minMoveCount);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    if (isSecondVisible) {
      var secMoveCount = _dateTime.second * 6 * pi / 180;
      var secHandX = centerX + radius * 0.615 * sin(secMoveCount);
      var secHandY = centerY + radius * 0.615 * -cos(secMoveCount);
      canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush); 
    }

    canvas.drawCircle(center, radius * 0.12, centerFillBrush);

    var dashBrush = Paint()
      ..color = AppColors.lavender
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    var dashBrushBold = Paint()
      ..color = AppColors.lavender
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    var outerCircleRadius = radius;
    var innerCircleRadius = radius * 0.9;
    var sec60 = 6;
    // var hour12 = 30;
    for (int i = 0; i < 360; i += sec60) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), i == 0 || i % 30 == 0 ? dashBrushBold : dashBrush);
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return true;
    // throw UnimplementedError();
  }
}
