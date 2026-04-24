import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/drone_provider.dart';

class GlassyTopStatusBar extends StatelessWidget {
  final VoidCallback onTuneTap;
  final VoidCallback onSettingsTap;

  const GlassyTopStatusBar({
    Key? key,
    required this.onTuneTap,
    required this.onSettingsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DroneProvider>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wi-Fi Signal
                _buildStatusItem(
                  icon: Icons.wifi_rounded,
                  iconColor: Colors.blueAccent.shade100,
                  text: provider.pingMs > 0 ? "Signal: Stable" : "Searching...",
                ),
                
                // Ping/Latency
                _buildPingStatus(provider.pingMs),
                
                // Connection Status
                _buildConnectionStatus(provider.pingMs > 0),
                
                // IP Address & Tune Button grouped
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIpAddress("192.168.4.1"), // TODO: Get from provider if needed
                    const SizedBox(width: 15),
                    Container(
                      height: 25,
                      width: 1.5,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: onTuneTap,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4), width: 1.5),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.cyanAccent, size: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: onSettingsTap,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// ... (rest of the helper methods remain the same)

  Widget _buildStatusItem({required IconData icon, required Color iconColor, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPingStatus(int ping) {
    final bool isGood = ping < 50;
    final Color pingColor = isGood ? Colors.greenAccent : Colors.redAccent;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.speed_rounded, color: Colors.white70, size: 22),
        const SizedBox(width: 8),
        Text(
          "Ping: ${ping}ms",
          style: TextStyle(
            color: pingColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: pingColor.withValues(alpha: 0.6),
                blurRadius: 12,
              )
            ]
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus(bool isConnected) {
    final Color dotColor = isConnected ? Colors.greenAccent : Colors.redAccent;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            boxShadow: [
              BoxShadow(
                color: dotColor.withValues(alpha: 0.9),
                blurRadius: 12,
                spreadRadius: 3,
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "ESP32 Link",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildIpAddress(String ip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Text(
        ip,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontFamily: 'Courier', // Monospace style typography
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
