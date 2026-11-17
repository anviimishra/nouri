import XCTest
@testable import NouriDesign

/// Text must reach WCAG AA (4.5:1) in both light and dark mode.
final class ContrastTests: XCTestCase {
    private func assertAA(_ fg: ColorToken, on bg: ColorToken, _ name: String, file: StaticString = #filePath, line: UInt = #line) {
        let light = fg.light.contrast(with: bg.light)
        let dark = fg.dark.contrast(with: bg.dark)
        XCTAssertGreaterThanOrEqual(light, 4.5, "\(name) light: \(light)", file: file, line: line)
        XCTAssertGreaterThanOrEqual(dark, 4.5, "\(name) dark: \(dark)", file: file, line: line)
    }

    func testTextOnCanvas() {
        assertAA(NouriPalette.textPrimary, on: NouriPalette.canvas, "primary text")
        assertAA(NouriPalette.textSecondary, on: NouriPalette.canvas, "secondary text")
    }

    func testTextOnCard() {
        assertAA(NouriPalette.textPrimary, on: NouriPalette.card, "primary on card")
        assertAA(NouriPalette.textSecondary, on: NouriPalette.card, "secondary on card")
    }

    func testInkShadesOnCardAndCanvas() {
        for bg in [NouriPalette.canvas, NouriPalette.card] {
            assertAA(NouriPalette.clayInk, on: bg, "clay ink")
            assertAA(NouriPalette.oliveInk, on: bg, "olive ink")
        }
    }

    func testButtonLabels() {
        assertAA(NouriPalette.onAccent, on: NouriPalette.accent, "primary button label")
        assertAA(NouriPalette.textSecondary, on: NouriPalette.canvas, "text link label")
    }

    func testBrandColorsAreUsedExactly() {
        XCTAssertEqual(NouriPalette.canvas.light, RGB(0xF6F0E7))
        XCTAssertEqual(NouriPalette.sand.light, RGB(0xE6D6C2))
        XCTAssertEqual(NouriPalette.clay.light, RGB(0xC77D5B))
        XCTAssertEqual(NouriPalette.olive.light, RGB(0x89916B))
        XCTAssertEqual(NouriPalette.textPrimary.light, RGB(0x343D30))
    }

    func testContrastMathMatchesWCAG() {
        XCTAssertEqual(RGB(0x000000).contrast(with: RGB(0xFFFFFF)), 21, accuracy: 0.01)
    }
}
