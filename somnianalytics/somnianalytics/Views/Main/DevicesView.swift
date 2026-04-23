import CoreBluetooth
import Foundation
import SwiftUI

struct DevicesView: View {
    @Environment(Router.self) private var router: Router
    @Environment(SomnitrixManager.self) private var ble: SomnitrixManager

    private let purple = Color(red: 0.55, green: 0.35, blue: 0.95)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.3),
                    Color.clear
                ]),
                center: .top,
                startRadius: 10,
                endRadius: 500
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Devices")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 16)

                    // Description card
                    Text("This is where you can configure connections to a Somnitrix device. If you have previously connected to your Somnitrix device, you can see its details here. If you haven't connected to a Somnitrix device yet, you can select one from the list below.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(16)
                        .background(Color.white.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    if let device = ble.connected {
                        // Connected device card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("YOUR SOMNITRIX")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.5))
                                .tracking(2)

                            VStack(spacing: 0) {
                                deviceRow(title: "Device Name", value: device.name)
                                Divider().background(Color.white.opacity(0.05))
                                deviceRow(title: "Device UUID", value: device.id.uuidString)
                            }
                            .background(Color.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                            Button(action: { ble.disconnect() }) {
                                Text("Disconnect")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.red.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }

                    } else if ble.state == .poweredOff {
                        // Bluetooth is disabled
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.05))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color.white.opacity(0.3))
                            }
                            .padding(.top, 40)

                            Text("Bluetooth Disabled")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.3))

                            Text("Make sure you have Bluetooth enabled on your iPhone device.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.2))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)
                    } else if ble.state == .poweredOn && ble.discovered.isEmpty {
                        // No devices found
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.05))
                                    .frame(width: 70, height: 70)
                                Image(systemName: "antenna.radiowaves.left.and.right")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color.white.opacity(0.3))
                            }
                            .padding(.top, 40)

                            Text("No devices found")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.3))

                            Text("Make sure your Somnitrix device is powered on.")
                                .font(.system(size: 14))
                                .foregroundColor(Color.white.opacity(0.2))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(32)

                    } else {
                        // Discovered devices list
                        VStack(alignment: .leading, spacing: 12) {
                            Text("AVAILABLE DEVICES")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.white.opacity(0.5))
                                .tracking(2)

                            VStack(spacing: 0) {
                                ForEach(ble.discovered) { device in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(device.name)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                        Spacer()
                                        Button(action: { ble.connect(device: device) }) {
                                            Text("Connect")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(purple)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 6)
                                                .background(purple.opacity(0.15))
                                                .clipShape(Capsule())
                                        }
                                    }
                                    .padding(16)

                                    if device.id != ble.discovered.last?.id {
                                        Divider()
                                            .background(Color.white.opacity(0.05))
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                            .background(Color.white.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func deviceRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding(16)
    }
}

#Preview {
    DevicesView()
}
