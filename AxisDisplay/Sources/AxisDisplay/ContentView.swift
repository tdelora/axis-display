import SwiftUI

struct ContentView: View {

    @StateObject private var motion = MotionManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                if motion.isAvailable {
                    axisGrid
                } else {
                    unavailableMessage
                }
            }
            .padding()
            .navigationTitle("Axis Display")
        }
    }

    // MARK: - Sub-views

    private var axisGrid: some View {
        VStack(spacing: 20) {
            AxisRow(axis: "X", label: "Roll",  value: motion.x, accel: motion.accelX, color: .red)
            AxisRow(axis: "Y", label: "Pitch", value: motion.y, accel: motion.accelY, color: .green)
            AxisRow(axis: "Z", label: "Yaw",   value: motion.z, accel: motion.accelZ, color: .blue)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGroupedBackground))
        )
    }

    private var unavailableMessage: some View {
        VStack(spacing: 12) {
            Image(systemName: "gyroscope")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("Motion sensors not available on this device.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - AxisRow

private struct AxisRow: View {
    let axis: String
    let label: String
    let value: Double
    let accel: Double
    let color: Color

    var body: some View {
        HStack {
            // Axis indicator
            Text(axis)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(color))

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Text(String(format: "%.4f rad", value))
                    .font(.system(.body, design: .monospaced))
                Text(String(format: "%.4f g", accel))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Degrees conversion
            Text(String(format: "%.1f°", value * 180 / .pi))
                .font(.system(.title3, design: .monospaced))
                .foregroundColor(color)
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
