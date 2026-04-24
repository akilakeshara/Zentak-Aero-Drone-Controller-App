# Zentak Aero - Next-Gen Drone Controller 🚁✨

**Zentak Aero** is a high-performance, professional drone controller application built with Flutter. It features a cinematic Glassmorphic UI design, real-time telemetry visualization, and cloud-integrated flight logging.

## 🚀 Version: 1.0.0 (Stable Release)

## ✨ Key Features

- **3D Artificial Horizon**: Real-time 3D attitude indicator (Pitch/Roll) with high-speed telemetry synchronization.
- **Glassmorphic HUD**: A premium, state-of-the-art cinematic dashboard designed for maximum visibility and aesthetic appeal.
- **Real-time UDP Communication**: Low-latency control data transmission and telemetry reception optimized for ESP32 flight controllers.
- **Firebase Flight Logs**: Automatic cloud synchronization of flight data. Track duration, battery health, and flight history in real-time.
- **Live PID Tuning**: Fine-tune your drone's flight performance (P, I, D for Pitch/Roll) on-the-fly via UDP commands.
- **Advanced Settings**: Customize control sensitivity, measurement units (Metric/Imperial), safety limits, and UI themes.
- **Cinematic Branding**: Custom animated splash screen and professional high-tech app icons.

## 🛠 Technical Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Communication**: UDP (User Datagram Protocol)
- **Backend**: Firebase Cloud Firestore
- **Hardware Compatibility**: ESP32 / Arduino based flight controllers

## 📡 Communication Protocol (UDP)

### Control Data (App -> Drone)
Format: `T:[throttle],Y:[yaw],P:[pitch],R:[roll],A:[arming_state]`
- Example: `T:255,Y:127,P:127,R:127,A:1`

### PID Tuning (App -> Drone)
Format: `PID:[p],[i],[d],[type]`
- Example: `PID:1.25,0.05,0.15,PITCH`

### Telemetry Data (Drone -> App)
Format: `B:[battery],P:[pitch],R:[roll]`
- Example: `B:98,P:2,R:-1`

## 📦 Getting Started

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Configure `android/app/google-services.json` for Firebase integration.
4. Use the provided `mock_drone_server.js` to test without physical hardware.
5. Build and deploy to your mobile device.

---
Developed with ❤️ by Zentak Aero Team.
