import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/udp_service.dart';
import '../../../core/services/firebase_service.dart';

class DroneProvider extends ChangeNotifier {
  final UdpService _udpService = UdpService();
  
  // Joystick values (0-255, 127 is neutral)
  int _throttle = 0;
  int _yaw = 127;
  int _pitch = 127;
  int _roll = 127;
  
  bool _isArmed = false;
  
  // Real-time telemetry data
  int _batteryPercent = 100;
  int _dronePitch = 0;
  int _droneRoll = 0;
  int _pingMs = 0;
  DateTime _lastPacketTime = DateTime.now();
  
  Timer? _transmitTimer;
  StreamSubscription? _telemetrySubscription;

  DroneProvider() {
    _initServices();
  }

  Future<void> _initServices() async {
    await _udpService.initialize();
    
    // Listen for incoming telemetry from drone
    _telemetrySubscription = _udpService.telemetryStream.listen(_onTelemetryReceived);

    _transmitTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      _transmitData();
    });
  }

  void connectToDrone(String ip, int port) {
    _udpService.updateTarget(ip, port);
    notifyListeners();
  }

  void _onTelemetryReceived(String message) {
    // Expected format: "B:95,P:2,R:-1"
    try {
      final parts = message.split(',');
      for (var part in parts) {
        final kv = part.split(':');
        if (kv.length == 2) {
          final key = kv[0].trim();
          final value = int.tryParse(kv[1].trim()) ?? 0;
          
          if (key == 'B') _batteryPercent = value;
          if (key == 'P') _dronePitch = value;
          if (key == 'R') _droneRoll = value;
        }
      }
      _pingMs = DateTime.now().difference(_lastPacketTime).inMilliseconds;
      _lastPacketTime = DateTime.now();
      notifyListeners();
    } catch (e) {
      debugPrint("Telemetry parse error: $e");
    }
  }

  void _transmitData() {
    _udpService.sendControlData(
      throttle: _throttle,
      yaw: _yaw,
      pitch: _pitch,
      roll: _roll,
      isArmed: _isArmed,
    );
  }

  // State Getters
  int get throttle => _throttle;
  int get yaw => _yaw;
  int get pitch => _dronePitch; // Return actual drone pitch
  int get roll => _droneRoll;   // Return actual drone roll
  bool get isArmed => _isArmed;
  int get batteryPercent => _batteryPercent;
  int get pingMs => _pingMs;

  void updateLeftJoystick(double x, double y) {
    _yaw = ((x + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    _throttle = ((-y + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    notifyListeners();
  }

  void updateRightJoystick(double x, double y) {
    // These are intended setpoints (to be sent), not the received telemetry
    _roll = ((x + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    _pitch = ((-y + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    notifyListeners();
  }
  
  // Note: We might want separate getters for 'setpoint' vs 'actual' if we show both.
  // For now, let's keep it simple.

  void resetLeftJoystick() {
    _yaw = 127;
    notifyListeners();
  }

  void resetRightJoystick() {
    _pitch = 127;
    _roll = 127;
    notifyListeners();
  }

  void toggleArm() {
    _isArmed = !_isArmed;
    if (!_isArmed) {
      // Log the flight session when disarming (end of flight)
      FirebaseService().logFlight(
        date: DateTime.now(),
        duration: "00:05:23", // TODO: Calculate actual duration
        status: "Successful Flight",
        isSuccess: true,
        maxSpeed: 45.0,
        maxAltitude: 120.0,
      );
      _throttle = 0; 
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _transmitTimer?.cancel();
    _telemetrySubscription?.cancel();
    _udpService.dispose();
    super.dispose();
  }
}
