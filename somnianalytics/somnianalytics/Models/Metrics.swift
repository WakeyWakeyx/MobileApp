import Foundation
import SwiftData

/// Represents sensor readings stored internally via SwiftData.
@Model
class Metrics {
    /// The temperature reading.
    var temperature: Float
    
    /// The humidity reading,
    var humidity: Float
    
    /// The read heart reading,
    var heartRate: Float
    
    /// The accelerometer readings in the x axis.
    var accelerometerX: Int
    
    /// The accelerometer readings in the y-axis.
    var accelerometerY: Int
    
    /// The accelerometer readings in the z-axis.
    var accelerometerZ: Int
    
    /// The time at which these readings were received and stored.
    var timestamp: Date = Date.now
    
    init(
        temperature: Float,
        humidity: Float,
        heartRate: Float,
        accelerometerX: Int,
        accelerometerY: Int,
        accelerometerZ: Int,
        timestamp: Date = Date.now
    ) {
        self.temperature = temperature
        self.humidity = humidity
        self.heartRate = heartRate
        self.accelerometerX = accelerometerX
        self.accelerometerY = accelerometerY
        self.accelerometerZ = accelerometerZ
        self.timestamp = timestamp
    }
}
