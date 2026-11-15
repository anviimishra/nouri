import Foundation

public struct DailyMetric: Codable, Hashable, Sendable {
    public let date: String          // yyyy-MM-dd in the user's timezone
    public let metric: MetricName
    public let value: Double
    public let unit: String
    public let sourceBundle: String

    enum CodingKeys: String, CodingKey {
        case date, metric, value, unit
        case sourceBundle = "source_bundle"
    }

    public init(date: String, metric: MetricName, value: Double, unit: String, sourceBundle: String) {
        self.date = date
        self.metric = metric
        self.value = value
        self.unit = unit
        self.sourceBundle = sourceBundle
    }
}
