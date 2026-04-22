/// Represents sensor metrics sent by a Somnitrix device via Bluetooth.
struct MetricsPacket: Codable {
    /// The temperature reading.
    let temperature: Float
    /// The humidity reading.
    let humidity: Float
    /// The heart rate reading.
    let heart_rate: Float
    /// The accelerometer readings.
    let accelerometer: AccelerometerPacket
    
    init(
        temperature: Float,
        humidity: Float,
        heart_rate: Float,
        accelerometer: AccelerometerPacket
    ) {
        self.temperature = temperature
        self.humidity = humidity
        self.heart_rate = heart_rate
        self.accelerometer = accelerometer
    }
    
    /// Returns a SwiftData model representation of this packet.
    func toModel() -> Metrics {
        return Metrics(
            temperature: self.temperature,
            humidity: self.humidity,
            heartRate: self.heart_rate,
            accelerometerX: self.accelerometer.x,
            accelerometerY: self.accelerometer.y,
            accelerometerZ: self.accelerometer.z
        )
    }
}
