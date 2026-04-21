import Foundation
import SwiftUI

struct DevicesView: View {
    @Environment(Router.self) private var router: Router
    @State var ble: SomniManager = SomniManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Available Devices")
                .font(.system(size: 24))
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
