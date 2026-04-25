import 'dart:ui';
import 'package:flutter/material.dart';

class GlassyKillSwitch extends StatefulWidget {
  final VoidCallback onKill;

  const GlassyKillSwitch({super.key, required this.onKill});

  @override
  State<GlassyKillSwitch> createState() => _GlassyKillSwitchState();
}

class _GlassyKillSwitchState extends State<GlassyKillSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // 1-second long press to trigger kill switch
      duration: const Duration(seconds: 1), 
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isTriggered) {
        setState(() {
          _isTriggered = true;
        });
        
        // Execute the kill callback
        widget.onKill();
        
        // Reset the button visually after a few seconds for re-use if necessary
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isTriggered = false;
            });
            _controller.reverse();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!_isTriggered) _controller.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_isTriggered) _controller.reverse();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!_isTriggered) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 240,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.redAccent.shade700.withValues(alpha: 0.15 + (progress * 0.4)),
                  border: Border.all(
                    color: Colors.redAccent.shade400.withValues(alpha: 0.5 + (progress * 0.5)),
                    width: 2.0 + (progress * 2.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.shade400.withValues(alpha: 0.3 + (progress * 0.5)),
                      blurRadius: 15 + (progress * 25),
                      spreadRadius: progress * 8,
                    )
                  ]
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Visual Progress Fill
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade400.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                    ),
                    
                    // Button Content
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isTriggered ? Icons.warning_rounded : Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 24 + (progress * 4), 
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _isTriggered ? "MOTORS KILLED" : "KILL MOTORS",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
