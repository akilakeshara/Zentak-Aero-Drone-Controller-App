import 'package:flutter/material.dart';

class AdvancedSettingsScreen extends StatefulWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  State<AdvancedSettingsScreen> createState() => _AdvancedSettingsScreenState();
}

class _AdvancedSettingsScreenState extends State<AdvancedSettingsScreen> {
  // Mock settings state (in a real app, these would be in a dedicated SettingsProvider)
  double _sensitivity = 0.8;
  String _unit = "Metric (m/s)";
  bool _voiceFeedback = true;
  double _lowBatteryWarning = 20.0;
  Color _primaryGlowColor = Colors.cyanAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    children: [
                      _buildSectionHeader("FLIGHT CONTROLS"),
                      _buildGlassySlider("JOYSTICK SENSITIVITY", _sensitivity, 0.1, 1.0, (v) => setState(() => _sensitivity = v)),
                      _buildGlassyDropdown("MEASUREMENT UNIT", ["Metric (m/s)", "Imperial (ft/s)"], _unit, (v) => setState(() => _unit = v!)),
                      
                      const SizedBox(height: 30),
                      _buildSectionHeader("SAFETY & TELEMETRY"),
                      _buildGlassySlider("LOW BATTERY WARNING", _lowBatteryWarning, 10, 50, (v) => setState(() => _lowBatteryWarning = v), suffix: "%"),
                      _buildGlassySwitch("VOICE FEEDBACK", _voiceFeedback, (v) => setState(() => _voiceFeedback = v)),
                      
                      const SizedBox(height: 30),
                      _buildSectionHeader("UI CUSTOMIZATION"),
                      _buildColorPicker(),
                      
                      const SizedBox(height: 50),
                      _buildSaveButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          ),
          const SizedBox(width: 15),
          const Text(
            "ADVANCED SETTINGS",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Text(
        title,
        style: TextStyle(color: _primaryGlowColor, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 3),
      ),
    );
  }

  Widget _buildGlassySlider(String label, double value, double min, double max, ValueChanged<double> onChanged, {String suffix = ""}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
              Text("${value.toStringAsFixed(value > 10 ? 0 : 2)}$suffix", style: TextStyle(color: _primaryGlowColor, fontWeight: FontWeight.w900)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            activeColor: _primaryGlowColor,
            inactiveColor: Colors.white10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassySwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _primaryGlowColor,
            activeTrackColor: _primaryGlowColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassyDropdown(String label, List<String> options, String current, ValueChanged<String?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: current,
            dropdownColor: Colors.black,
            underline: Container(),
            style: TextStyle(color: _primaryGlowColor, fontWeight: FontWeight.bold),
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [Colors.cyanAccent, Colors.purpleAccent, Colors.pinkAccent, Colors.orangeAccent];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: colors.map((color) {
        bool isSelected = _primaryGlowColor == color;
        return GestureDetector(
          onTap: () => setState(() => _primaryGlowColor = color),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Colors.white : color.withValues(alpha: 0.5), width: isSelected ? 3 : 1),
              boxShadow: [
                if (isSelected) BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 15)
              ],
            ),
            child: Center(child: Container(width: 15, height: 15, decoration: BoxDecoration(color: color, shape: BoxShape.circle))),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings Saved Locally")));
        Navigator.pop(context);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [_primaryGlowColor, _primaryGlowColor.withBlue(255)]),
          boxShadow: [BoxShadow(color: _primaryGlowColor.withValues(alpha: 0.3), blurRadius: 20)],
        ),
        child: const Center(
          child: Text("APPLY CHANGES", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 3)),
        ),
      ),
    );
  }
}
