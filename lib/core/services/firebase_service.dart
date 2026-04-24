import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  /// Initialize Firebase - must be called in main()
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      debugPrint("Firebase Initialized Successfully");
    } catch (e) {
      debugPrint("Firebase Initialization Error: $e");
    }
  }

  /// Log a new flight session
  Future<void> logFlight({
    required DateTime date,
    required String duration,
    required String status,
    required bool isSuccess,
    required double maxSpeed,
    required double maxAltitude,
  }) async {
    try {
      await _firestore.collection('flight_logs').add({
        'date': date.toIso8601String(),
        'duration': duration,
        'status': status,
        'isSuccess': isSuccess,
        'maxSpeed': maxSpeed,
        'maxAltitude': maxAltitude,
        'pilot': 'Zentak Pilot', // Placeholder for now
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("Flight Log saved to Firestore");
    } catch (e) {
      debugPrint("Error logging flight to Firestore: $e");
    }
  }

  /// Stream of historical flight logs
  Stream<QuerySnapshot> getFlightLogs() {
    return _firestore
        .collection('flight_logs')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
