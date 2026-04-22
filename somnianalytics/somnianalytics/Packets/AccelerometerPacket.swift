/// Represents accelerometer readings sent by Somnitrix device via Bluetooth.
struct AccelerometerPacket: Codable {
    /// The accelerometer reading in the x axis.
    let x: Int
    /// The accelerometer reading in the y axis.
    let y: Int
    /// The accelerometer reading in the z axis.
    let z: Int
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}
