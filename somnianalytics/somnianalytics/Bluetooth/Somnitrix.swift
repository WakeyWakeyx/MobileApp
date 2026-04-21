import CoreBluetooth
import Foundation

struct Somnitrix: Identifiable {
    static let SERVICE_UUID: CBUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    static let RECEIVED_UUID: CBUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    static let TRANSMITTER_UUID: CBUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    
    let id: UUID
    let name: String
    let peripheral: CBPeripheral
    
    init(id: UUID, name: String, peripheral: CBPeripheral) {
        self.id = id
        self.name = name
        self.peripheral = peripheral
    }
}
