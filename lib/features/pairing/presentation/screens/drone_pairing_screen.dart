import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../dashboard/presentation/screens/drone_dashboard_screen.dart';
import '../widgets/animated_radar.dart';
import '../widgets/glassy_text_field.dart';

class DronePairingScreen extends StatefulWidget {
  const DronePairingScreen({Key? key}) : super(key: key);

  @override
  State<DronePairingScreen> createState() => _DronePairingScreenState();
}

class _DronePairingScreenState extends State<DronePairingScreen> with SingleTickerProviderStateMixin {
  bool _isConnecting = false;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _handleConnect() {
    setState(() {
      _isConnecting = true;
    });
    
    // Simulate connection delay
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      // Navigate with a smooth fade transition
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => const DroneDashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(Colors.black, Colors.deepPurple.shade900, _bgController.value)!,
                      Color.lerp(Colors.blue.shade900, Colors.black, _bgController.value)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          
          // Noise/Glass Overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left Side: Titles & Radar
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "ZENTAK AERO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            letterSpacing: 8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "SEARCHING FOR ESP32 DRONE...",
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 10,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const AnimatedRadar(),
                      ],
                    ),
                    
                    // Right Side: Settings & Connect
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Connection Settings
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const GlassyTextField(
                              label: "IP ADDRESS",
                              defaultValue: "192.168.4.1",
                              icon: Icons.cell_tower_rounded,
                            ),
                            const SizedBox(width: 20),
                            const GlassyTextField(
                              label: "UDP PORT",
                              defaultValue: "4210",
                              icon: Icons.settings_ethernet_rounded,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Action Button
                        GestureDetector(
                          onTap: _isConnecting ? null : _handleConnect,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 300,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                    colors: [Colors.cyanAccent, Colors.blueAccent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    )
                                  ]
                                ),
                                child: Center(
                                  child: _isConnecting
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        "CONNECT & PAIR",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          letterSpacing: 4,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
