import 'dart:ui';
import 'package:flutter/material.dart';

class GlassyJoystick extends StatefulWidget {
  final void Function(double x, double y) onChanged;
  final VoidCallback onRelease;
  final bool isLeft;
  final double size;

  const GlassyJoystick({
    Key? key,
    required this.onChanged,
    required this.onRelease,
    required this.isLeft,
    this.size = 200.0,
  }) : super(key: key);

  @override
  State<GlassyJoystick> createState() => _GlassyJoystickState();
}

class _GlassyJoystickState extends State<GlassyJoystick> {
  Offset _position = Offset.zero;
  
  double get _baseSize => widget.size;
  double get _stickSize => widget.size * 0.4;

  void _updatePosition(Offset localPosition) {
    final double maxOffset = (_baseSize - _stickSize) / 2;
    // Calculate vector from center
    Offset center = Offset(_baseSize / 2, _baseSize / 2);
    Offset offset = localPosition - center;

    // Constrain the stick to the circular boundary
    if (offset.distance > maxOffset) {
      offset = Offset.fromDirection(offset.direction, maxOffset);
    }

    setState(() {
      _position = offset;
    });

    // Normalize values between -1.0 and 1.0
    widget.onChanged(
      offset.dx / maxOffset,
      offset.dy / maxOffset,
    );
  }

  void _onPanStart(DragStartDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updatePosition(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (widget.isLeft) {
        // Left joystick (Throttle) typically doesn't auto-center on the Y-axis
        _position = Offset(0, _position.dy); 
      } else {
        // Right joystick centers both axes
        _position = Offset.zero;
      }
    });
    widget.onRelease();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_baseSize / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: _baseSize,
            height: _baseSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 25,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Minimalistic Crosshairs
                Container(
                  width: _baseSize,
                  height: 1,
                  color: Colors.white.withOpacity(0.15),
                ),
                Container(
                  width: 1,
                  height: _baseSize,
                  color: Colors.white.withOpacity(0.15),
                ),
                // Movable Stick Component
                Transform.translate(
                  offset: _position,
                  child: Container(
                    width: _stickSize,
                    height: _stickSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.8),
                          Colors.blueAccent.withOpacity(0.3),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 3,
                        )
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: _stickSize * 0.35,
                        height: _stickSize * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
