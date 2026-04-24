import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class UdpClient {
  RawDatagramSocket? _socket;
  String _targetIp = '192.168.4.1';
  int _targetPort = 4210;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  /// Initialize the UDP socket
  Future<void> connect(String ip, int port) async {
    try {
      _targetIp = ip;
      _targetPort = port;
      
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      _isConnected = true;
      
      debugPrint('UDP Socket bound to ${_socket?.address.address}:${_socket?.port}');
      
      _socket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? dg = _socket?.receive();
          if (dg != null) {
            _onDataReceived(dg.data);
          }
        }
      });
    } catch (e) {
      debugPrint('UDP Connection Error: $e');
      _isConnected = false;
    }
  }

  /// Send control data packet
  void sendData(Uint8List data) {
    if (_socket != null && _isConnected) {
      _socket?.send(data, InternetAddress(_targetIp), _targetPort);
    }
  }

  /// Send string data (for debugging or simpler protocols)
  void sendString(String message) {
    sendData(Uint8List.fromList(message.codeUnits));
  }

  void _onDataReceived(Uint8List data) {
    // Handle incoming telemetry from ESP32
    String message = String.fromCharCodes(data);
    debugPrint('UDP Received: $message');
    // TODO: Broadcast this to the DroneProvider
  }

  void disconnect() {
    _socket?.close();
    _isConnected = false;
    debugPrint('UDP Socket closed');
  }
}
