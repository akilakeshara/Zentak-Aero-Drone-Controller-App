import 'dart:ui';
import 'package:flutter/material.dart';

class GlassyTrimButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GlassyTrimButton({Key? key, required this.icon, required this.onTap}) : super(key: key);

  @override
  State<GlassyTrimButton> createState() => _GlassyTrimButtonState();
}

class _GlassyTrimButtonState extends State<GlassyTrimButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _controller.forward().then((_) {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withValues(alpha: 0.05 + (progress * 0.15)),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2 + (progress * 0.4)),
                    width: 1.0,
                  ),
                  boxShadow: [
                    if (progress > 0)
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: progress * 0.5),
                        blurRadius: 15,
                        spreadRadius: progress * 3,
                      )
                  ]
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: Colors.white.withValues(alpha: 0.7 + (progress * 0.3)),
                    size: 24 + (progress * 4),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
