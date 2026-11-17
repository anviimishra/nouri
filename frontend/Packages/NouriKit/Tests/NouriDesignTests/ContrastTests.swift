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
        assertAA(NouriPalette.accent, on: NouriPalette.canvas, "accent text")
    }

    func testTextOnGlows() {
        assertAA(NouriPalette.textSecondary, on: NouriPalette.canvasGlowWarm, "secondary on warm glow")
        assertAA(NouriPalette.textSecondary, on: NouriPalette.canvasGlowCool, "secondary on cool glow")
    }

    func testTextOnCard() {
        assertAA(NouriPalette.textPrimary, on: NouriPalette.card, "primary on card")
        assertAA(NouriPalette.textSecondary, on: NouriPalette.card, "secondary on card")
    }

    func testButtonLabels() {
        assertAA(NouriPalette.onAccent, on: NouriPalette.accent, "primary button label")
        assertAA(NouriPalette.peach, on: NouriPalette.card, "peach accent on card")
    }

    func testContrastMathMatchesWCAG() {
        XCTAssertEqual(RGB(0x000000).contrast(with: RGB(0xFFFFFF)), 21, accuracy: 0.01)
    }
}
