import XCTest
@testable import NouriKit

final class DailyMetricTests: XCTestCase {
    func testDecodesSnakeCaseRow() throws {
        let json = #"{"date":"2026-11-14","metric":"resting_hr","value":54,"unit":"bpm","source_bundle":"com.apple.health"}"#
        let row = try JSONDecoder().decode(DailyMetric.self, from: Data(json.utf8))
        XCTAssertEqual(row.metric, .restingHR)
        XCTAssertEqual(row.value, 54)
    }
}
