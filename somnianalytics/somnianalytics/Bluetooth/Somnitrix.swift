import CoreBluetooth
import Foundation

/// Represents a discovered or connected Somnitrix device.
struct Somnitrix: Identifiable {
    /// The expected UUID of the Somnitrix's UART module.
    static let SERVICE_UUID: CBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    /// The expected UUID of the Somnitrix's UART receiver characteristic.
    static let RECEIVER_UUID: CBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    /// The expected UUID of the Somnitrix's UART transmitter characteristic.
    static let TRANSMITTER_UUID: CBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    
    /// The UUID of the Somnitrix device.
    let id: UUID
    /// The name of the Somnitrix device or '<unknown>' if no name was found.
    let name: String
    /// The underlying bluetooth peripheral object attached to this device.
    let peripheral: CBPeripheral
    
    init(id: UUID, name: String, peripheral: CBPeripheral) {
        self.id = id
        self.name = name
        self.peripheral = peripheral
    }
}
