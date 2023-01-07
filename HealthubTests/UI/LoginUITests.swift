import XCTest

final class LoginUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSuccessfulLogin() throws {
        
        // Test setup
        let app = XCUIApplication()
        let retrievalTimeout = 2.0
        app.launch()
        
        // UI elements
        let loginButton = app.buttons["loginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: retrievalTimeout))
        let continueButton = app.buttons["continueWithEmailButton"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: retrievalTimeout))
        let emailField = app.textFields["emailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: retrievalTimeout))
        let passwordField = app.textFields["passwordField"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: retrievalTimeout))
        
        // Performs login
        continueButton.tap()
        emailField.tap()
        emailField.typeText("astroTester@gmail.com")
        passwordField.tap()
        passwordField.typeText("Testing97@")
        loginButton.tap()
        
        // Condition
        
    }
    
    func testFailureLogin() throws {
        
    }
    
}
