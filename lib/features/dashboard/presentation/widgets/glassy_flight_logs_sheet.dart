import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/firebase_service.dart';

class GlassyFlightLogsSheet extends StatelessWidget {
  const GlassyFlightLogsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => const GlassyFlightLogsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Draggable sheet to allow sliding up from the bottom smoothly
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                border: Border(
                  top: BorderSide(
                    color: Colors.cyanAccent.withValues(alpha: 0.6),
                    width: 2.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: 0.15),
                    blurRadius: 50,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  // Glowing Pill Handle
                  Container(
                    width: 70,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withValues(alpha: 0.8),
                          blurRadius: 12,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Main Scrollable Content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 40),
                        _buildSessionStatsSection(),
                        const SizedBox(height: 40),
                        _buildHistoricalLogsSection(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withValues(alpha: 0.2),
                blurRadius: 15,
              )
            ],
            image: const DecorationImage(
              // Safe placeholder image
              image: NetworkImage("https://ui-avatars.com/api/?name=Zentak+Aero&background=0D8ABC&color=fff&size=200"), 
              fit: BoxFit.cover,
            )
          ),
        ),
        const SizedBox(width: 25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "PILOT STATUS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                letterSpacing: 3,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Active / Ready",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ],
            )
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "TOTAL FLIGHT HOURS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                letterSpacing: 2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "124H 45M",
              style: TextStyle(
                color: Colors.cyanAccent.shade400,
                fontSize: 24,
                fontFamily: 'Courier',
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSessionStatsSection() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CURRENT SESSION",
            style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("FLIGHT TIME", "00:05:23", Icons.timer_outlined, Colors.orangeAccent),
              _buildStatItem("MAX SPEED", "45 KM/H", Icons.speed_rounded, Colors.pinkAccent),
              _buildStatItem("MAX ALTITUDE", "120 M", Icons.landscape_rounded, Colors.purpleAccent),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Courier', fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildHistoricalLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "HISTORICAL FLIGHT LOGS",
          style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseService().getFlightLogs(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Text("Error loading logs", style: TextStyle(color: Colors.redAccent));
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
            }

            final logs = snapshot.data?.docs ?? [];
            if (logs.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("No flights recorded yet.", style: TextStyle(color: Colors.white54)),
              );
            }

            return Column(
              children: logs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildLogCard(
                  data['date'] ?? '',
                  data['duration'] ?? '',
                  data['status'] ?? '',
                  data['isSuccess'] ?? true,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogCard(String date, String duration, String status, bool isSuccess) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        // Subtle left border to indicate success/failure
        boxShadow: [
          BoxShadow(
            color: (isSuccess ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(-5, 0),
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: (isSuccess ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.5),
                      blurRadius: 5,
                    )
                  ]
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: TextStyle(
                      color: isSuccess ? Colors.greenAccent.shade200 : Colors.redAccent.shade200, 
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              duration,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Courier', fontWeight: FontWeight.w900),
            ),
          )
        ],
      ),
    );
  }
}
