import SwiftUI

struct PredictionResultsCard: View {
    let prediction: SleepStagePrediction?
    let latestData: PredictionLiveData?
    let isModelLoaded: Bool
    let bufferProgress: Double
    let bufferedSampleCount: Int
    let requiredSampleCount: Int
    let latestError: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("LIVE PREDICTION")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.5))
                        .tracking(2)

                    Text(statusTitle)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                Text(statusBadge)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(statusColor.opacity(0.15))
                    .clipShape(Capsule())
            }

            Text(statusDescription)
                .font(.system(size: 14))
                .foregroundColor(Color.white.opacity(0.6))

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Model window")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.75))
                    Spacer()
                    Text("\(bufferedSampleCount) / \(requiredSampleCount) samples")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.55, green: 0.35, blue: 0.95), Color.blue.opacity(0.85)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: proxy.size.width * bufferProgress)
                    }
                }
                .frame(height: 10)
            }

            if let prediction {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Probabilities")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    ForEach(probabilityRows, id: \.label) { row in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(row.label)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.75))
                                Spacer()
                                Text(row.value)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            GeometryReader { proxy in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.08))
                                    Capsule()
                                        .fill(row.label == prediction.label ? Color.green.opacity(0.9) : Color.white.opacity(0.22))
                                        .frame(width: proxy.size.width * row.progress)
                                }
                            }
                            .frame(height: 8)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Latest Sensor Packet")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)

                if let latestData {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        metricTile(title: "Temp", value: String(format: "%.2f", latestData.temperature))
                        metricTile(title: "Heart Rate", value: String(format: "%.0f", latestData.heartRate))
                        metricTile(title: "Acc X", value: String(format: "%.0f", latestData.accX))
                        metricTile(title: "Acc Y", value: String(format: "%.0f", latestData.accY))
                        metricTile(title: "Acc Z", value: String(format: "%.0f", latestData.accZ))
                    }
                } else {
                    Text("No bluetooth data has been received yet.")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.45))
                }
            }

            if let latestError {
                Text(latestError)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.red.opacity(0.9))
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var statusTitle: String {
        prediction?.label ?? (isModelLoaded ? "Collecting data" : "Model unavailable")
    }

    private var statusBadge: String {
        if prediction != nil {
            return "Active"
        }
        return isModelLoaded ? "Buffering" : "Offline"
    }

    private var statusColor: Color {
        if prediction != nil {
            return .green
        }
        return isModelLoaded ? Color(red: 0.55, green: 0.35, blue: 0.95) : .red
    }

    private var statusDescription: String {
        if let prediction {
            return "Latest sleep stage prediction updated at \(formattedTime(prediction.timestamp))."
        }
        if isModelLoaded {
            return "The model is loaded and waiting for enough bluetooth samples to fill the prediction window."
        }
        return "The Core ML model could not be loaded, so predictions are currently unavailable."
    }

    private var probabilityRows: [(label: String, value: String, progress: Double)] {
        guard let prediction else { return [] }
        return prediction.probabilities
            .sorted { $0.key < $1.key }
            .map {
                (
                    label: $0.key,
                    value: String(format: "%.1f%%", $0.value * 100),
                    progress: max(0, min($0.value, 1))
                )
            }
    }

    private func metricTile(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.45))
                .tracking(1)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func formattedTime(_ date: Date) -> String {
        date.formatted(date: .omitted, time: .shortened)
    }
}
