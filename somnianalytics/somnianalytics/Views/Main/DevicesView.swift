import Foundation
import SwiftUI

struct DevicesView: View {
    @Environment(Router.self) private var router: Router
    @Environment(SomniManager.self) private var ble: SomniManager
    
    var body: some View {
        VStack(alignment: .leading) {
            if let somnitrix = ble.connected {
                Text("Looks like you're already connected to a Somnitrix device. You are good to go then!")
                    .font(.subheadline)
                    .background(Color.gray.opacity(0.5))
                    .multilineTextAlignment(.center)
                InfoItem(title: "Device Name", value: somnitrix.name)
                InfoItem(title: "Device UUID", value: somnitrix.id.uuidString)
                Button("Disconnect", action: { ble.disconnect() })
            } else {
                Text("Like you're not connected to a Somnitrix device. Please choose from one of the below devices and connec to it.")
                    .font(.subheadline)
                    .background(Color.gray.opacity(0.5))
                    .multilineTextAlignment(.center)
                if ble.discovered.isEmpty {
                    Text("No devices found. Make sure Bluetooth is powered on and try again!")
                } else {
                    List(ble.discovered) { device in
                        HStack(alignment: .center) {
                            Text(device.name)
                            Spacer()
                            Button("Connect", action: {})
                        }
                    }
                }
            }
        }
        .navigationTitle("Devices")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func InfoItem(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}

#Preview {
    DevicesView()
}
