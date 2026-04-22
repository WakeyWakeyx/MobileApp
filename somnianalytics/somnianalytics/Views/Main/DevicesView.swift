import Foundation
import SwiftUI

struct DevicesView: View {
    @Environment(Router.self) private var router: Router
    @Environment(SomniManager.self) private var ble: SomniManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("This is where you can configure connections to a Somnitrix device. If you have previously connected to your Somnitrix device, you can see its details here. If you haven't connected to a Somnitrix device yet, you can select one from the list below.")
                .font(.subheadline)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.25)))
            if let device = ble.connected {
                Section("About Your Somnitrix") {
                    LabeledString(title: "Device Name", value: device.name)
                    LabeledString(title: "Device UUID", value: device.id.uuidString)
                    Button("Disconnect", action: { ble.disconnect() })
                }
            } else if ble.discovered.isEmpty {
                Text("No devices found. Make sure your Somnitrix device is powered on.")
            } else {
                List(ble.discovered) { device in
                    LabeledContent(
                        content: {
                            Button("Connect", action: { ble.connect(device: device) })
                        },
                        label: {
                            Text(device.name)
                        }
                    )
                }
            }
            Spacer()
        }
        .padding(10)
        .navigationTitle("Devices")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func LabeledString(title: String, value: String) -> some View {
        LabeledContent(
            content: { Text(value) },
            label: { Text(title) }
        )
    }
}

#Preview {
    DevicesView()
}
