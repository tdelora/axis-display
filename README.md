# Axis Display

An iOS app that reads live device-motion data from CoreMotion and displays the **X, Y, Z** rotation values on screen, clearly labelled with their orientation name:

| Axis | Label | Description |
|------|-------|-------------|
| **X** | **Roll**  | Rotation around the X-axis (left/right tilt) |
| **Y** | **Pitch** | Rotation around the Y-axis (forward/back tilt) |
| **Z** | **Yaw**   | Rotation around the Z-axis (compass rotation) |

Each value is shown in **radians** and converted to **degrees** for easy reading.

## Project layout

```
AxisDisplay.xcodeproj/                  – Xcode project
AxisDisplay/
└── Sources/
    └── AxisDisplay/
        ├── AxisDisplayApp.swift        – @main SwiftUI app entry point
        ├── ContentView.swift           – UI: axis rows with colour-coded badges
        ├── MotionManager.swift         – CoreMotion wrapper (ObservableObject)
        ├── Info.plist                  – App configuration (includes NSMotionUsageDescription)
        └── Assets.xcassets/            – App icon and accent colour assets
```

## Requirements

- Xcode 15 or later
- iOS 16+ deployment target
- A physical iOS device (CoreMotion attitude data is not available in the Simulator)

## Running the app

1. Open `AxisDisplay.xcodeproj` in Xcode (double-click the file or use **File → Open…**).
2. In the project settings, set your development team under **Signing & Capabilities**.
3. Select your connected iOS device as the run destination.
4. Press **Run** (⌘R).

The screen will show three rows — one for each axis — updating at 30 Hz as you move the device.