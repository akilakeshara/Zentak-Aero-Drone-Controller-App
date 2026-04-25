import 'dart:ui';
import 'package:flutter/material.dart';

class GlassyTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;

  const GlassyTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 220,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Courier', fontWeight: FontWeight.bold, fontSize: 16),
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.white54, size: 20),
              labelText: label,
              labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, letterSpacing: 1),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }
}
