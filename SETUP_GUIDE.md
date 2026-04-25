# Zentak Aero - Full Setup & Run Guide 🚀

This guide explains how to set up the development environment, run the mock drone server, and launch the Zentak Aero app.

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your machine:

1.  **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
2.  **Node.js**: Required for the Mock Drone Server. [Install Node.js](https://nodejs.org/)
3.  **Android Studio / Xcode**: For mobile emulation or physical device deployment.
4.  **Firebase Account**: (Optional) For cloud flight logging.

---

## 🛠 Step 1: Initialize the Project

First, navigate to the project directory and install the necessary dependencies for both Flutter and the Mock Server.

```bash
# Install Flutter dependencies
flutter pub get

# Check if Flutter is ready
flutter doctor
```

---

## 📡 Step 2: Run the Mock Drone Server

Since testing with a real drone (ESP32) isn't always possible, use the provided Node.js mock server. This server simulates UDP telemetry and responds to control signals.

1.  Open a terminal in the root directory.
2.  Run the server:
    ```bash
    node mock_drone_server.js
    ```
3.  **Important**: Note down your computer's **Local IP Address** (e.g., `192.168.1.XX`). Both your phone and computer must be on the same Wi-Fi network.

---

## 📱 Step 3: Launch the App

### Option A: Local Debugging (USB/Emulator)
Connect your device and run:
```bash
flutter run
```

### Option B: Build the Release APK
If you want to install the app on an Android device without a computer:
```bash
flutter build apk --release
```
The file will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🔗 Step 4: Connecting the App to the Server

1.  Open the **Zentak Aero** app on your phone.
2.  Navigate to the **Pairing Screen**.
3.  Enter the **Local IP Address** of your computer (from Step 2).
4.  The default port is set to **4210**.
5.  Click **Connect**.
6.  Once connected, you will see real-time battery and attitude data on the dashboard.

---

## 🎮 Controls & Interaction

-   **Joystick (Left)**: Throttle & Yaw.
-   **Joystick (Right)**: Pitch & Roll.
-   **Arm Switch**: Must be ON to send control signals.
-   **PID Tuning**: Accessible via the settings icon to adjust flight stability.

---

## ⚠️ Troubleshooting

-   **UDP Timeout**: Ensure your Firewall isn't blocking Port `4210`.
-   **Connection Failed**: Double-check if your phone and PC are on the same Wi-Fi network.
-   **Firebase Error**: Ensure you have added the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) files to the respective folders.

---
*Developed by Zentak Aero Team.*
