// TODO: Way too simple, garbage bin code
// There has to be something I missed here.

import CoreBluetooth
import Foundation
import SwiftData

/// Class responsible for managing the connection to Somnitrix devices and receiving data packets from them.
@MainActor @Observable
class SomnitrixManager: NSObject {
    /// The CBCentralManager we use for handling BLE connections with the hardware.
    private var manager: CBCentralManager!
    /// The currently discovered Somnitrix devices when scanning for them.
    private(set) var discovered: [Somnitrix] = []
    /// The currently connected Somnitrix device, or nil if no device has been connected yet
    private(set) var connected: Somnitrix? = nil
    /// Is this SomnitrixManager currently scanning for devices?
    private(set) var scanning: Bool = false
    /// The current state of  the underlying CBCentralManager.
    private(set) var state: CBManagerState = .unknown
    /// The SwiftData ModelContext for locally storing sensor metrics as they are received.
    private let context: ModelContext
    private var predictionManager: MLModel_Manager?
    
    init(context: ModelContext) {
        self.context = context
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }

    func setPredictionManager(_ predictionManager: MLModel_Manager) {
        self.predictionManager = predictionManager
    }
    
    /// Tells the underlying CBCentralManager to look for Bluetooth devices.
    /// By default, this filters out any devices that don't have the same UUID as
    /// the wearable we have created.
    func discover() {
        manager.scanForPeripherals(withServices: [Somnitrix.SERVICE_UUID])
        self.scanning = true
    }
    
    /// Connects to the specified, previously-discovered Somnitrix device.
    /// NOTE: This method also stops further scanning of Bluetooth devices.
    func connect(device: Somnitrix) {
        manager.stopScan()
        manager.connect(device.peripheral)
        device.peripheral.delegate = self
        self.scanning = false
        self.connected = device
        self.discovered.removeAll()
    }
    
    /// Disconnects the currently connected device, if any, and unsubscribes from any
    /// additional bluetooth reception events.
    func disconnect() {
        // Ensure that we are already connected to a somnitrix before proceding.
        guard let peripheral = connected?.peripheral else { return }
        guard peripheral.state == .connected else { return }
        
        // Unsubscribe from transmitter characteristics (should really only be 1).
        peripheral.services?
            .filter { $0.uuid == Somnitrix.SERVICE_UUID }
            .flatMap { $0.characteristics ?? [] }
            .filter { $0.uuid == Somnitrix.TRANSMITTER_UUID }
            .forEach { peripheral.setNotifyValue(false, for: $0) }
        
        // Finally, cleanup and sever the connection with the manager.
        self.connected = nil
        peripheral.delegate = nil
        manager.cancelPeripheralConnection(peripheral)
    }
}

extension SomnitrixManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.state = central.state
        guard connected == nil && central.state == .poweredOn else { return }
        discover()
    }
    
    /// Called when a new Bluetooth device is discovered.
    func centralManager(
        _ manager: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi: NSNumber
    ) {
        debugPrint("Discovered device: UUID=\(peripheral.identifier.uuidString), Name=\(peripheral.name ?? "<unknown>")")
        if !discovered.contains(where: { $0.id == peripheral.identifier }) {
            discovered.append(Somnitrix(
                id: peripheral.identifier,
                name: peripheral.name ?? "<unknown>",
                peripheral: peripheral
            ))
        }
    }
    
    /// Called when a new Bluetooth device is connected.
    func centralManager(
        _ manager: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        debugPrint("Connected device: UUID=\(peripheral.identifier.uuidString), Name=\(peripheral.name ?? "<unknown>")")
        peripheral.delegate = self
        peripheral.discoverServices([Somnitrix.SERVICE_UUID])
    }
}

extension SomnitrixManager: CBPeripheralDelegate {
    /// Called when the services advertised by a peripheral have been discovered.
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered Service: \(service.uuid.uuidString)")
            peripheral.discoverCharacteristics([Somnitrix.TRANSMITTER_UUID], for: service)
        }
    }
    
    /// Called when the characteristics for a device's service have been discovered.
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        guard let characteristics = service.characteristics else { return }
        // We are only interested in the hardware metrics characteristic, so we subscribe to that.
        // So we ignore everything else (there shouldn't be anything else either way, I think).
        for characteristic in characteristics where characteristic.uuid == Somnitrix.TRANSMITTER_UUID {
            //&& characteristic.properties.contains(.read)
            //&& characteristic.properties.contains(.notify)
            debugPrint("Discovered Characteristic: \(characteristic.uuid.uuidString)")
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    /// Called when a characteristic for a connected device's service is updated.
    /// We read the value of this characteristic, deserialize it, and then store it locally.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        guard let data = characteristic.value else {
            debugPrint("Bluetooth payload was empty")
            return
        }
        //let metrics = JSONDecoder().decode(SensorMetrics.self, from: data)
        //context.insert(metrics)
        do {
            debugPrint("Received Metrics For: \(characteristic.uuid.uuidString)")
            let strings = String(data: data, encoding: .utf8)
            debugPrint("Received Json: \(strings ?? "<ERROR>")")
            let packet = try JSONDecoder().decode(MetricsPacket.self, from: data)
            predictionManager?.ingest(packet: packet)
            let metrics = packet.toModel()
            context.insert(metrics)
        } catch {
            fatalError("Failed to decode sensor metrics")
            //TODO
        }
    }
}
