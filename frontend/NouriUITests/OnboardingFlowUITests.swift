import XCTest

/// Walks the whole onboarding flow by tapping, the way a user would.
final class OnboardingFlowUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testTapsThroughOnboardingToHome() {
        let app = XCUIApplication()
        app.launchArguments = ["-onboardingStep", "welcome"]
        app.launch()

        let getStarted = app.buttons["Get started"]
        XCTAssertTrue(getStarted.waitForExistence(timeout: 10))
        getStarted.tap()
        XCTAssertTrue(app.staticTexts["Connect your apps"].waitForExistence(timeout: 10), "Get started should open Connect")

        app.buttons["Connect"].tap()
        XCTAssertTrue(app.staticTexts["Connected"].waitForExistence(timeout: 5))

        app.buttons["Continue"].tap()
        XCTAssertTrue(app.staticTexts["Any goals in mind?"].waitForExistence(timeout: 5))

        app.buttons["Skip for now"].tap()
        XCTAssertTrue(app.staticTexts["You're all set"].waitForExistence(timeout: 5))

        app.buttons["Start using Nouri"].tap()
        XCTAssertTrue(app.staticTexts["You're in"].waitForExistence(timeout: 5), "Finishing should land on Home")

        // Relaunching without the debug argument skips onboarding.
        app.terminate()
        app.launchArguments = []
        app.launch()
        XCTAssertTrue(app.staticTexts["You're in"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["Get started"].exists)

        // The debug restart button brings onboarding back.
        app.buttons["Restart onboarding"].tap()
        XCTAssertTrue(app.buttons["Get started"].waitForExistence(timeout: 10))
    }
}
