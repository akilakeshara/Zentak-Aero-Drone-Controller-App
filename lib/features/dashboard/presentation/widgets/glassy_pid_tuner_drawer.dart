import 'dart:ui';
import 'package:flutter/material.dart';

class GlassyPIDTunerDrawer extends StatefulWidget {
  final VoidCallback onClose;
  final bool isOpen;

  const GlassyPIDTunerDrawer({
    Key? key,
    required this.onClose,
    required this.isOpen,
  }) : super(key: key);

  @override
  State<GlassyPIDTunerDrawer> createState() => _GlassyPIDTunerDrawerState();
}

class _GlassyPIDTunerDrawerState extends State<GlassyPIDTunerDrawer> {
  // Pitch PID
  double _pitchP = 1.25;
  double _pitchI = 0.05;
  double _pitchD = 0.15;

  // Roll PID
  double _rollP = 1.25;
  double _rollI = 0.05;
  double _rollD = 0.15;

  @override
  Widget build(BuildContext context) {
    // 450 is the width of the drawer
    final double drawerWidth = 400.0;

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
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "LIVE PID TUNING",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      child: IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close_rounded, color: Colors.white),
                        iconSize: 20,
                        splashRadius: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("PITCH SETUP", Colors.cyanAccent),
                        _buildGlassySlider("P (Proportional)", _pitchP, 0, 5, (v) => setState(() => _pitchP = v), Colors.cyanAccent),
                        _buildGlassySlider("I (Integral)", _pitchI, 0, 1, (v) => setState(() => _pitchI = v), Colors.cyanAccent),
                        _buildGlassySlider("D (Derivative)", _pitchD, 0, 1, (v) => setState(() => _pitchD = v), Colors.cyanAccent),
                        
                        const SizedBox(height: 40),
                        
                        _buildSectionHeader("ROLL SETUP", Colors.purpleAccent.shade200),
                        _buildGlassySlider("P (Proportional)", _rollP, 0, 5, (v) => setState(() => _rollP = v), Colors.purpleAccent.shade200),
                        _buildGlassySlider("I (Integral)", _rollI, 0, 1, (v) => setState(() => _rollI = v), Colors.purpleAccent.shade200),
                        _buildGlassySlider("D (Derivative)", _rollD, 0, 1, (v) => setState(() => _rollD = v), Colors.purpleAccent.shade200),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Sync Action Button
                GestureDetector(
                  onTap: () {
                    // Placeholder for UDP Sync Action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("PID Values Synced to Flight Controller!"),
                        backgroundColor: Colors.blueAccent.withValues(alpha: 0.9),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    widget.onClose();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.purpleAccent.shade400, Colors.blueAccent.shade400],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      )
                    ),
                    child: const Center(
                      child: Text(
                        "SYNC TO DRONE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            width: 5, 
            height: 18, 
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: accent.withValues(alpha: 0.6), blurRadius: 10)
              ]
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassySlider(String label, double value, double min, double max, ValueChanged<double> onChanged, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70, 
                  fontSize: 14, 
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: activeColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 13,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeColor,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: Colors.white,
              overlayColor: activeColor.withValues(alpha: 0.3),
              trackHeight: 6.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
