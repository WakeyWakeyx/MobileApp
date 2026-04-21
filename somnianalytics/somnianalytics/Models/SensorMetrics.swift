import Foundation
import SwiftData

/// Stores sensor metrics as sent by the wearable device.
@Model
class SensorMetrics {
    /// The read body temperature value.
    var temperature: Float
    
    /// The read body humidity value.
    var humidity: Float
    
    /// The read heart rate value.
    var heart_rate: Float
    
    /// The read accelerometer values.
    var accelerometer: AccelerometerMetrics
    
    /// The time at which these readings were received.
    var timestamp: Date = Date.now
    
    init(
        temperature: Float,
        humidity: Float,
        heart_rate: Float,
        accelerometer: AccelerometerMetrics,
        timestamp: Date = Date.now
    ) {
        self.temperature = temperature
        self.humidity = humidity
        self.heart_rate = heart_rate
        self.accelerometer = accelerometer
        self.timestamp = timestamp
    }
}

struct SensorMetricsDto: Codable {
    let temperature: Float
    let humidity: Float
    let heart_rate: Float
    let accelerometer: AccelerometerMetricsDto
    
    init(
        temperature: Float,
        humidity: Float,
        heart_rate: Float,
        accelerometer: AccelerometerMetricsDto
    ) {
        self.temperature = temperature
        self.humidity = humidity
        self.heart_rate = heart_rate
        self.accelerometer = accelerometer
    }
    
    func toSensorMetrics() -> SensorMetrics {
        return SensorMetrics(
            temperature: temperature,
            humidity: humidity,
            heart_rate: heart_rate,
            accelerometer: accelerometer.toAccelerometerMetrics()
        )
    }
}

/// Accelerometer values sent by the wearable device.
@Model
class AccelerometerMetrics {
    /// Accelerometer value in the x axis.
    var x: Int
    
    /// Accelerometer value in the y axis.
    var y: Int
    
    /// Accelerometer value in the z axis.
    var z: Int
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

struct AccelerometerMetricsDto: Codable {
    let x: Int
    let y: Int
    let z: Int
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func toAccelerometerMetrics() -> AccelerometerMetrics {
        return AccelerometerMetrics(x: x, y: y, z: z)
    }
}
