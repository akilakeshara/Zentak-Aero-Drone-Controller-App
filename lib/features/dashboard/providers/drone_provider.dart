import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/udp_service.dart';

class DroneProvider extends ChangeNotifier {
  final UdpService _udpService = UdpService();
  
  // Joystick values (Mapped to 0-255, 127 is center/neutral)
  int _throttle = 0; // Throttle starts at 0
  int _yaw = 127;
  int _pitch = 127;
  int _roll = 127;
  
  bool _isArmed = false;
  
  // Mock telemetry data
  final int _batteryPercent = 98;
  
  // High frequency update timer to simulate continuous UDP stream
  Timer? _transmitTimer;

  DroneProvider() {
    _initServices();
  }

  Future<void> _initServices() async {
    await _udpService.initialize();
    
    // Start periodic transmission for real-time control (e.g., 50Hz / 20ms)
    _transmitTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      _transmitData();
    });
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
  int get pitch => _pitch;
  int get roll => _roll;
  bool get isArmed => _isArmed;
  int get batteryPercent => _batteryPercent;

  // Update Left Joystick: Y-axis is Throttle, X-axis is Yaw
  void updateLeftJoystick(double x, double y) {
    // Map -1.0 to 1.0 range into 0 to 255
    _yaw = ((x + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    _throttle = ((-y + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    notifyListeners();
  }

  // Update Right Joystick: Y-axis is Pitch, X-axis is Roll
  void updateRightJoystick(double x, double y) {
    _roll = ((x + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    _pitch = ((-y + 1.0) / 2.0 * 255).clamp(0, 255).toInt();
    notifyListeners();
  }

  void resetLeftJoystick() {
    _yaw = 127;
    // Note: Throttle intentionally does NOT auto-center
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
      // Safety measure: Cut throttle immediately when disarmed
      _throttle = 0; 
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _transmitTimer?.cancel();
    _udpService.dispose();
    super.dispose();
  }
}
