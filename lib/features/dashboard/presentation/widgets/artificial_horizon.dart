import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drone_provider.dart';

class ArtificialHorizon extends StatelessWidget {
  final double size;

  const ArtificialHorizon({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DroneProvider>();
    
    // Pitch and Roll from telemetry (assuming degrees)
    final double pitch = provider.pitch.toDouble();
    final double roll = provider.roll.toDouble();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          painter: HorizonPainter(pitch: pitch, roll: roll),
        ),
      ),
    );
  }
}

class HorizonPainter extends CustomPainter {
  final double pitch; // In degrees
  final double roll;  // In degrees

  HorizonPainter({required this.pitch, required this.roll});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Rotate for Roll
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-roll * pi / 180);
    canvas.translate(-center.dx, -center.dy);

    // 2. Draw Sky and Ground
    // Pitch shifts the horizon up or down. 
    // We'll map 1 degree to 2 pixels of movement.
    final double pitchOffset = pitch * 2.0;
    
    final Paint skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue.shade900, Colors.cyan.shade700],
      ).createShader(Rect.fromLTRB(0, -size.height + pitchOffset, size.width, size.height + pitchOffset));

    final Paint groundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.brown.shade900, Colors.orange.shade900.withValues(alpha: 0.8)],
      ).createShader(Rect.fromLTRB(0, size.height + pitchOffset, size.width, size.height * 2 + pitchOffset));

    // Draw the sky/ground boundary
    canvas.drawRect(
      Rect.fromLTRB(-size.width, -size.height * 2 + pitchOffset, size.width * 2, size.height / 2 + pitchOffset),
      skyPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(-size.width, size.height / 2 + pitchOffset, size.width * 2, size.height * 4 + pitchOffset),
      groundPaint,
    );

    // 3. Draw Horizon Line
    final Paint horizonPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(-size.width, size.height / 2 + pitchOffset),
      Offset(size.width * 2, size.height / 2 + pitchOffset),
      horizonPaint,
    );

    // 4. Draw Pitch Lines (Scales)
    final Paint linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    
    for (int i = -60; i <= 60; i += 10) {
      if (i == 0) continue;
      double y = size.height / 2 + pitchOffset - (i * 2.0);
      double lineWidth = (i % 20 == 0) ? 40 : 20;
      canvas.drawLine(
        Offset(center.dx - lineWidth / 2, y),
        Offset(center.dx + lineWidth / 2, y),
        linePaint,
      );
    }

    canvas.restore();

    // 5. Draw Static Airplane Reference (Indicator)
    final Paint refPaint = Paint()
      ..color = Colors.yellowAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Center dot
    canvas.drawCircle(center, 3, refPaint..style = PaintingStyle.fill);
    
    // Wings
    canvas.drawLine(Offset(center.dx - 40, center.dy), Offset(center.dx - 10, center.dy), refPaint);
    canvas.drawLine(Offset(center.dx + 10, center.dy), Offset(center.dx + 40, center.dy), refPaint);
    canvas.drawLine(Offset(center.dx - 10, center.dy), Offset(center.dx - 10, center.dy + 5), refPaint);
    canvas.drawLine(Offset(center.dx + 10, center.dy), Offset(center.dx + 10, center.dy + 5), refPaint);
  }

  @override
  bool shouldRepaint(covariant HorizonPainter oldDelegate) {
    return oldDelegate.pitch != pitch || oldDelegate.roll != roll;
  }
}
