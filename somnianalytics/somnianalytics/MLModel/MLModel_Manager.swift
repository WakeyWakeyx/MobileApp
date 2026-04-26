//
//  MLModel_Manager.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 4/23/26.
//

import CoreML
import Foundation
import Observation

struct SleepStagePrediction {
    let label: String
    let probabilities: [String: Double]
    let timestamp: Date
}

struct PredictionLiveData {
    let temperature: Double
    let accX: Double
    let accY: Double
    let accZ: Double
    let heartRate: Double
}

private struct LiveSensorSample {
    let temperature: Double
    let accX: Double
    let accY: Double
    let accZ: Double
    let heartRate: Double
}

@MainActor
@Observable
final class MLModel_Manager {
    private let classLabels = ["Awake", "Light Sleep", "Deep Sleep"]
    private let samplesPerEpoch = 1920
    private let epochCount = 15
    private let channelCount = 5
    private let predictionStrideSamples = 1920

    private var model: best_model?
    private var bufferedSamples: [LiveSensorSample] = []
    private var newSamplesSincePrediction = 0

    private(set) var latestPrediction: SleepStagePrediction?
    private(set) var latestError: String?
    private(set) var isModelLoaded = false
    private(set) var latestReceivedData: PredictionLiveData?

    init() {
        loadModel()
    }

    func ingest(packet: MetricsPacket) {
        let sample = LiveSensorSample(
            temperature: Double(packet.temperature),
            accX: Double(packet.accelerometer.x),
            accY: Double(packet.accelerometer.y),
            accZ: Double(packet.accelerometer.z),
            heartRate: Double(packet.heart_rate)
        )

        // The model expects 64 Hz input while BLE currently delivers 32 Hz, so
        // each sample is duplicated once to match the trained timeline.
        latestReceivedData = PredictionLiveData(
            temperature: sample.temperature,
            accX: sample.accX,
            accY: sample.accY,
            accZ: sample.accZ,
            heartRate: sample.heartRate
        )
        bufferedSamples.append(sample)
        bufferedSamples.append(sample)
        newSamplesSincePrediction += 2
        trimBufferIfNeeded()

        guard isModelLoaded else { return }
        guard bufferedSamples.count >= requiredSampleCount else { return }
        guard newSamplesSincePrediction >= predictionStrideSamples else { return }

        runPrediction()
    }

    private var requiredSampleCount: Int {
        samplesPerEpoch * epochCount
    }

    var requiredSamplesForPrediction: Int {
        requiredSampleCount
    }

    var bufferedSampleCount: Int {
        bufferedSamples.count
    }

    var bufferProgress: Double {
        guard requiredSampleCount > 0 else { return 0 }
        return min(Double(bufferedSamples.count) / Double(requiredSampleCount), 1)
    }

    var hasEnoughDataForPrediction: Bool {
        bufferedSamples.count >= requiredSampleCount
    }

    private func trimBufferIfNeeded() {
        let overflow = bufferedSamples.count - requiredSampleCount
        guard overflow > 0 else { return }
        bufferedSamples.removeFirst(overflow)
    }

    private func loadModel() {
        do {
            model = try best_model(configuration: MLModelConfiguration())
            isModelLoaded = true
            latestError = nil
        } catch {
            latestError = "Failed to load Core ML model: \(error.localizedDescription)"
        }
    }

    private func runPrediction() {
        do {
            let features = try makeFeatureArray()
            guard let model else { return }
            let input = best_modelInput(features: features)
            let output = try model.prediction(input: input)
            let probabilities = probabilities(from: output.probabilities)
            guard let best = probabilities.max(by: { $0.value < $1.value }) else {
                latestError = "Model returned no probabilities."
                return
            }

            latestPrediction = SleepStagePrediction(
                label: best.key,
                probabilities: probabilities,
                timestamp: .now
            )
            latestError = nil
            newSamplesSincePrediction = 0
        } catch {
            latestError = "Prediction failed: \(error.localizedDescription)"
        }
    }

    private func makeFeatureArray() throws -> MLMultiArray {
        let array = try MLMultiArray(
            shape: [1, NSNumber(value: epochCount), NSNumber(value: channelCount), NSNumber(value: samplesPerEpoch)],
            dataType: .float32
        )

        let startIndex = bufferedSamples.count - requiredSampleCount
        let window = bufferedSamples[startIndex...]

        for (sampleOffset, sample) in window.enumerated() {
            let epoch = sampleOffset / samplesPerEpoch
            let timeIndex = sampleOffset % samplesPerEpoch
            let values = [
                sample.temperature,
                sample.accX,
                sample.accY,
                sample.accZ,
                sample.heartRate
            ]

            for (channel, value) in values.enumerated() {
                let index: [NSNumber] = [
                    0,
                    NSNumber(value: epoch),
                    NSNumber(value: channel),
                    NSNumber(value: timeIndex)
                ]
                array[index] = NSNumber(value: Float(value))
            }
        }

        return array
    }
    private func probabilities(from multiArray: MLMultiArray) -> [String: Double] {
        let probabilities = multiArray
            .enumeratedValues()
            .prefix(classLabels.count)
            .enumerated()
            .reduce(into: [String: Double]()) { result, pair in
                let label = classLabels[pair.offset]
                result[label] = pair.element
            }

        return probabilities
    }
}

private extension MLMultiArray {
    func enumeratedValues() -> [Double] {
        (0..<count).map { index in
            self[[NSNumber(value: index)]].doubleValue
        }
    }
}
