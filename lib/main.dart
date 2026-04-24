import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/dashboard/presentation/screens/drone_dashboard_screen.dart';
import 'features/dashboard/providers/drone_provider.dart';
import 'features/pairing/presentation/screens/drone_pairing_screen.dart';
import 'core/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService().initialize();
  
  // Force landscape orientation for the controller
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DroneProvider()),
        ],
        child: const DroneApp(),
      ),
    );
  });
}

class DroneApp extends StatelessWidget {
  const DroneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zentak Aero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const DronePairingScreen(),
    );
  }
}
