import XCTest

final class OnBoardingUITests: XCTestCase {
    
    // Testing app target
    let app = XCUIApplication()
    let timer = 2.0
    let longTimer = 10.0
    
    // User Inputs
    let username = "testing@mail.com"
    let password = "test"
    
    override func setUpWithError() throws {
        // Setup code invocated before tests execution
        continueAfterFailure = false
        // Chooses the device orientation
        let device = XCUIDevice.shared
        device.orientation = .portrait
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app.unins
    }

    func testOnBoarding() throws {
        app.launchArguments = ["onboarding"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let calendarImage = app.images["CalendarImage"]
        let continueButton = app.buttons["OnBoardingButton"]
        let currentDate = app.staticTexts["CurrentDate"]
        
        // Assertions
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
        continueWithEmailButton.tap()
        XCTAssertTrue(loginButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        XCTAssertTrue(usernameField.value != nil)
        let insertedUsername = usernameField.value as? String
        XCTAssertEqual(insertedUsername, username)
        passwordField.tap()
        passwordField.typeText(password)
        XCTAssertTrue(passwordField.value != nil)
        loginButton.tap()
        XCTAssert(currentDate.waitForExistence(timeout: timer))
    }
}
