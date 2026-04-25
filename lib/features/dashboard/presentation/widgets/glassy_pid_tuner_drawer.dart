import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drone_provider.dart';

class GlassyPIDTunerDrawer extends StatefulWidget {
  final VoidCallback onClose;
  final bool isOpen;

  const GlassyPIDTunerDrawer({
    super.key,
    required this.onClose,
    required this.isOpen,
  });

  @override
  State<GlassyPIDTunerDrawer> createState() => _GlassyPIDTunerDrawerState();
}

class _GlassyPIDTunerDrawerState extends State<GlassyPIDTunerDrawer> {
  late double _pitchP, _pitchI, _pitchD;
  late double _rollP, _rollI, _rollD;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final provider = context.read<DroneProvider>();
      _pitchP = provider.pitchP;
      _pitchI = provider.pitchI;
      _pitchD = provider.pitchD;
      _rollP = provider.rollP;
      _rollI = provider.rollI;
      _rollD = provider.rollD;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = 400.0;
    final provider = context.read<DroneProvider>();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      top: 0,
      bottom: 0,
      right: widget.isOpen ? 0 : -drawerWidth - 50, 
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          bottomLeft: Radius.circular(35),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: drawerWidth,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 30,
              right: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              border: Border(
                left: BorderSide(
                  color: Colors.purpleAccent.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "LIVE PID TUNING",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSectionHeader("PITCH SETUP", Colors.cyanAccent),
                        _buildGlassySlider("P", _pitchP, 0, 5, (v) => setState(() => _pitchP = v), Colors.cyanAccent),
                        _buildGlassySlider("I", _pitchI, 0, 1, (v) => setState(() => _pitchI = v), Colors.cyanAccent),
                        _buildGlassySlider("D", _pitchD, 0, 1, (v) => setState(() => _pitchD = v), Colors.cyanAccent),
                        const SizedBox(height: 30),
                        _buildSectionHeader("ROLL SETUP", Colors.purpleAccent),
                        _buildGlassySlider("P", _rollP, 0, 5, (v) => setState(() => _rollP = v), Colors.purpleAccent),
                        _buildGlassySlider("I", _rollI, 0, 1, (v) => setState(() => _rollI = v), Colors.purpleAccent),
                        _buildGlassySlider("D", _rollD, 0, 1, (v) => setState(() => _rollD = v), Colors.purpleAccent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Sync both Pitch and Roll via UDP
                    provider.syncPID(p: _pitchP, i: _pitchI, d: _pitchD, type: 'PITCH');
                    provider.syncPID(p: _rollP, i: _rollI, d: _rollD, type: 'ROLL');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("PID Values Transmitted via UDP!")),
                    );
                    widget.onClose();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(colors: [Colors.purpleAccent, Colors.blueAccent]),
                    ),
                    child: const Center(
                      child: Text("SYNC TO DRONE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color accent) {
    return Row(
      children: [
        Container(width: 5, height: 18, color: accent),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGlassySlider(String label, double value, double min, double max, ValueChanged<double> onChanged, Color activeColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(value.toStringAsFixed(2), style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged, activeColor: activeColor),
      ],
    );
  }
}
