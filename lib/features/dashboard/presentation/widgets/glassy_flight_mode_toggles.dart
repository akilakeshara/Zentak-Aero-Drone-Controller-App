import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassyFlightModeToggles extends StatefulWidget {
  final Function(String mode) onModeChanged;

  const GlassyFlightModeToggles({super.key, required this.onModeChanged});

  @override
  State<GlassyFlightModeToggles> createState() => _GlassyFlightModeTogglesState();
}

class _GlassyFlightModeTogglesState extends State<GlassyFlightModeToggles> {
  String _activeMode = "ANGLE";

  void _switchMode(String mode) {
    if (_activeMode != mode) {
      HapticFeedback.lightImpact();
      setState(() {
        _activeMode = mode;
      });
      widget.onModeChanged(mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleOption("ANGLE", Icons.balance_rounded),
              const SizedBox(width: 8),
              _buildToggleOption("ACRO", Icons.sync_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleOption(String mode, IconData icon) {
    final isActive = _activeMode == mode;
    return GestureDetector(
      onTap: () => _switchMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? Colors.cyanAccent.withValues(alpha: 0.5) : Colors.transparent,
            width: 1.2,
          ),
          gradient: isActive 
              ? LinearGradient(
                  colors: [Colors.purpleAccent.withValues(alpha: 0.7), Colors.blueAccent.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.05)],
                ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white54,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              mode,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white54,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
