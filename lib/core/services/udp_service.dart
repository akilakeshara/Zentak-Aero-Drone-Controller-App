import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Service responsible for real-time UDP communication with the ESP32.
/// Firebase Initialization for future flight data logging should also be managed near this layer.
class UdpService {
  RawDatagramSocket? _socket;
  
  String _targetIp = "192.168.4.1"; 
  int _targetPort = 4210;

  // Stream for incoming telemetry data
  final _telemetryController = StreamController<String>.broadcast();
  Stream<String> get telemetryStream => _telemetryController.stream;

  Future<void> initialize({String? ip, int? port}) async {
    if (ip != null) _targetIp = ip;
    if (port != null) _targetPort = port;

    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      debugPrint("UDP Socket initialized on ${_socket?.address.address}:${_socket?.port}");
      
      _socket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = _socket?.receive();
          if (dg != null) {
            final message = utf8.decode(dg.data);
            _telemetryController.add(message);
          }
        }
      });
    } catch (e) {
      debugPrint("Error initializing UDP socket: $e");
    }
  }

  void updateTarget(String ip, int port) {
    _targetIp = ip;
    _targetPort = port;
  }

  void sendControlData({
    required int throttle,
    required int yaw,
    required int pitch,
    required int roll,
    required bool isArmed,
  }) {
    if (_socket == null) return;

    final payload = "T:$throttle,Y:$yaw,P:$pitch,R:$roll,A:${isArmed ? 1 : 0}";
    final data = utf8.encode(payload);

    try {
      _socket?.send(data, InternetAddress(_targetIp), _targetPort);
    } catch (e) {
      debugPrint("Error sending UDP data: $e");
    }
  }

  /// Send a custom string message via UDP
  void send(String message) {
    if (_socket == null) return;
    final data = utf8.encode(message);
    try {
      _socket?.send(data, InternetAddress(_targetIp), _targetPort);
    } catch (e) {
      debugPrint("Error sending custom UDP message: $e");
    }
  }

  void dispose() {
    _socket?.close();
    _telemetryController.close();
  }
}
