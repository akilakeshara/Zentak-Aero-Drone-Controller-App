import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drone_provider.dart';
import '../widgets/glassy_joystick.dart';
import '../widgets/glassy_top_status_bar.dart';
import '../widgets/glassy_pid_tuner_drawer.dart';
import '../widgets/glassy_kill_switch.dart';
import '../widgets/glassy_trim_button.dart';
import '../widgets/glassy_flight_logs_sheet.dart';
import '../widgets/glassy_flight_mode_toggles.dart';
import '../widgets/artificial_horizon.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class DroneDashboardScreen extends StatefulWidget {
  const DroneDashboardScreen({Key? key}) : super(key: key);

  @override
  State<DroneDashboardScreen> createState() => _DroneDashboardScreenState();
}

class _DroneDashboardScreenState extends State<DroneDashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  bool _isTunerOpen = false;

  @override
  void initState() {
    super.initState();
    // Animation controller for the slowly shifting dark gradients
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Animated Gradient Background (Zentak Style)
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(const Color(0xFF0F0C29), const Color(0xFF302B63), _bgAnimationController.value)!,
                      Color.lerp(const Color(0xFF302B63), const Color(0xFF1E103C), _bgAnimationController.value)!,
                      Color.lerp(const Color(0xFF1E103C), const Color(0xFF0F0C29), _bgAnimationController.value)!,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // 2. Glowing Abstract Orbs behind the UI
          Positioned(
            top: -150,
            left: -100,
            child: _buildGlowingOrb(Colors.pinkAccent.withOpacity(0.3), 400),
          ),
          Positioned(
            bottom: -200,
            right: -100,
            child: _buildGlowingOrb(Colors.cyanAccent.withOpacity(0.2), 500),
          ),
          Positioned(
            top: 50,
            right: 250,
            child: _buildGlowingOrb(Colors.purpleAccent.withOpacity(0.25), 300),
          ),

          // 3. Main Foreground Dashboard Layout
          SafeArea(
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 1000,
                  height: 550,
                  child: Column(
                    children: [
                      GlassyTopStatusBar(
                        onTuneTap: () => setState(() => _isTunerOpen = true),
                        onSettingsTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdvancedSettingsScreen()),
                          );
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Joystick (Throttle/Yaw)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GlassyJoystick(
                            isLeft: true,
                            size: 190,
                            onChanged: (x, y) => context.read<DroneProvider>().updateLeftJoystick(x, y),
                            onRelease: () => context.read<DroneProvider>().resetLeftJoystick(),
                          ),
                        ),
                        
                        // Center Panel (Telemetry & Arm Button)
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ArtificialHorizon(size: 80),
                              const SizedBox(height: 8),
                              GlassyKillSwitch(
                                onKill: () {
                                  // TODO: TRIGGER UDP ZERO-THROTTLE EMERGENCY PACKET HERE
                                  if (context.read<DroneProvider>().isArmed) {
                                    context.read<DroneProvider>().toggleArm();
                                  }
                                },
                              ),
                              const SizedBox(height: 15),
                              _buildTelemetryDashboard(context),
                              const SizedBox(height: 10),
                              _buildFlightLogsButton(context),
                              const SizedBox(height: 8),
                              _buildArmButton(context),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),

                        // Right Joystick with Trim Controls (Pitch/Roll)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GlassyTrimButton(
                                icon: Icons.keyboard_double_arrow_up_rounded,
                                onTap: () {
                                  // TODO: Pitch Trim Forward (+ value)
                                  // e.g. context.read<DroneProvider>().onTrimAdjust('pitch', 1);
                                }
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GlassyTrimButton(
                                    icon: Icons.keyboard_double_arrow_left_rounded,
                                    onTap: () {
                                      // TODO: Roll Trim Left (- value)
                                    }
                                  ),
                                  const SizedBox(width: 8),
                                  GlassyJoystick(
                                    isLeft: false,
                                    size: 190,
                                    onChanged: (x, y) => context.read<DroneProvider>().updateRightJoystick(x, y),
                                    onRelease: () => context.read<DroneProvider>().resetRightJoystick(),
                                  ),
                                  const SizedBox(width: 8),
                                  GlassyTrimButton(
                                    icon: Icons.keyboard_double_arrow_right_rounded,
                                    onTap: () {
                                      // TODO: Roll Trim Right (+ value)
                                    }
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              GlassyTrimButton(
                                icon: Icons.keyboard_double_arrow_down_rounded,
                                onTap: () {
                                  // TODO: Pitch Trim Backward (- value)
                                }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
          

          
          // 5. Live PID Tuning Drawer Overlay
          GlassyPIDTunerDrawer(
            isOpen: _isTunerOpen,
            onClose: () => setState(() => _isTunerOpen = false),
          ),
        ],
      ),
    );
  }

  // Floating Logs/Profile Button Helper
  Widget _buildFlightLogsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => GlassyFlightLogsSheet.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded, color: Colors.cyanAccent, size: 20),
            const SizedBox(width: 10),
            const Text(
              "FLIGHT LOGS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Generates massive blurred circular glowing orbs
  Widget _buildGlowingOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  // Center Glassmorphic Telemetry Panel
  Widget _buildTelemetryDashboard(BuildContext context) {
    final provider = context.watch<DroneProvider>();
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassyFlightModeToggles(
                onModeChanged: (mode) {
                  // TODO: Send UDP Mode Packet ('ANGLE' or 'ACRO')
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTelemetryItem("BATTERY", "${provider.batteryPercent}%", Icons.battery_charging_full_rounded, Colors.greenAccent),
                  const SizedBox(width: 25),
                  _buildTelemetryItem("PITCH", "${provider.pitch}", Icons.airplanemode_active_rounded, Colors.cyanAccent),
                  const SizedBox(width: 25),
                  _buildTelemetryItem("ROLL", "${provider.roll}", Icons.screen_rotation_rounded, Colors.purpleAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Glowing Slide/Toggle Button for Arming Motors
  Widget _buildArmButton(BuildContext context) {
    final isArmed = context.watch<DroneProvider>().isArmed;
    
    return GestureDetector(
      onTap: () => context.read<DroneProvider>().toggleArm(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        width: 220,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(
            colors: isArmed
                ? [Colors.redAccent.shade400.withOpacity(0.85), Colors.deepOrangeAccent.withOpacity(0.85)]
                : [Colors.greenAccent.shade400.withOpacity(0.7), Colors.tealAccent.shade400.withOpacity(0.7)],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isArmed ? Colors.redAccent.withOpacity(0.6) : Colors.greenAccent.withOpacity(0.5),
              blurRadius: 25,
              spreadRadius: 4,
            )
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isArmed ? Icons.warning_rounded : Icons.power_settings_new_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                isArmed ? "DISARM MOTORS" : "ARM MOTORS",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
