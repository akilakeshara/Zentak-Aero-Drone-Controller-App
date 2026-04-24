import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Service responsible for real-time UDP communication with the ESP32.
/// Firebase Initialization for future flight data logging should also be managed near this layer.
class UdpService {
  RawDatagramSocket? _socket;
  
  // Replace with the actual IP address and port of your ESP32 Access Point / UDP Server
  final String targetIp = "192.168.4.1"; 
  final int targetPort = 4210;

  Future<void> initialize() async {
    try {
      // Bind to any IPv4 address on a random ephemeral port
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      debugPrint("UDP Socket initialized on port ${_socket?.port}");
      
      // TODO: Initialize Firebase here in the future for logging flight data
      // await Firebase.initializeApp();
    } catch (e) {
      debugPrint("Error initializing UDP socket: $e");
    }
  }

  /// Sends the control payload to the ESP32 via UDP.
  /// Expects values mapped from 0 to 255.
  void sendControlData({
    required int throttle,
    required int yaw,
    required int pitch,
    required int roll,
    required bool isArmed,
  }) {
    if (_socket == null) return;

    // Example high-performance string payload. Alternatively, use raw bytes.
    final payload = "T:$throttle,Y:$yaw,P:$pitch,R:$roll,A:${isArmed ? 1 : 0}";
    final data = utf8.encode(payload);

    try {
      _socket?.send(data, InternetAddress(targetIp), targetPort);
    } catch (e) {
      debugPrint("Error sending UDP data: $e");
    }
  }

  void dispose() {
    _socket?.close();
  }
}
