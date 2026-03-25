import CoreMotion
import Combine

/// Minimum acceleration magnitude (in g) to consider the device as moving.
private let accelThreshold: Double = 0.05

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

    /// User acceleration along the X-axis (g)
    @Published var accelX: Double = 0.0
    /// User acceleration along the Y-axis (g)
    @Published var accelY: Double = 0.0
    /// User acceleration along the Z-axis (g)
    @Published var accelZ: Double = 0.0

    @Published var isAvailable: Bool = false

    // MARK: - Private

    private let manager = CMMotionManager()
    private let updateInterval: TimeInterval = 1.0 / 30.0  // 30 Hz
    /// Pending work item that zeros acceleration after the 5-second timeout.
    private var accelResetWorkItem: DispatchWorkItem?

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

            let accel = motion.userAcceleration
            let ax = accel.x, ay = accel.y, az = accel.z
            let isMoving = abs(ax) > accelThreshold
                        || abs(ay) > accelThreshold
                        || abs(az) > accelThreshold

            if isMoving {
                self.accelX = ax
                self.accelY = ay
                self.accelZ = az
                self.scheduleAccelReset()
            }
        }
    }

    /// Cancels any pending reset and schedules a new one 5 seconds from now.
    private func scheduleAccelReset() {
        accelResetWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.accelX = 0.0
            self?.accelY = 0.0
            self?.accelZ = 0.0
        }
        accelResetWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: workItem)
    }
}
