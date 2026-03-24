import CoreMotion
import Combine

/// Wraps CMMotionManager and publishes device attitude (roll, pitch, yaw)
/// along with the raw rotation-rate components mapped to X, Y, Z axes.
@MainActor
final class MotionManager: ObservableObject {

    // MARK: - Published values

    /// Roll  – rotation around the X-axis (radians)
    @Published var x: Double = 0.0
    /// Pitch – rotation around the Y-axis (radians)
    @Published var y: Double = 0.0
    /// Yaw   – rotation around the Z-axis (radians)
    @Published var z: Double = 0.0

    @Published var isAvailable: Bool = false

    // MARK: - Private

    private let manager = CMMotionManager()
    private let updateInterval: TimeInterval = 1.0 / 30.0  // 30 Hz

    // MARK: - Lifecycle

    init() {
        isAvailable = manager.isDeviceMotionAvailable
        startUpdates()
    }

    deinit {
        manager.stopDeviceMotionUpdates()
    }

    // MARK: - Motion updates

    private func startUpdates() {
        guard manager.isDeviceMotionAvailable else { return }

        manager.deviceMotionUpdateInterval = updateInterval
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            let attitude = motion.attitude
            self.x = attitude.roll   // X  →  Roll
            self.y = attitude.pitch  // Y  →  Pitch
            self.z = attitude.yaw    // Z  →  Yaw
        }
    }
}
