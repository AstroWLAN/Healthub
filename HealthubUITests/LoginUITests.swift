import XCTest

final class LoginUITests: XCTestCase {
    
    // Testing app target
    let app = XCUIApplication()
    let timer = 2.0
    
    // User Inputs
    let username = "testing@mail.com"
    let password = "test"
    let repeatPassword = "test"

    override func setUpWithError() throws {
        // Setup code invocated before tests execution
        continueAfterFailure = false
        // Chooses the device orientation
        let device = XCUIDevice.shared
        device.orientation = .portrait
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func testWelcome() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        
        // Assertions
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
    }

    func testLogin() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        
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
    }
    
    func testSignup() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let signupHyperlink = app.buttons["SignupHyperlink"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let repeatPasswordField = app.secureTextFields["RepeatPasswordField"]
        let signupButton = app.buttons["SignupButton"]
        
        // Assertions
        XCTAssertTrue(signupHyperlink.waitForExistence(timeout: timer))
        signupHyperlink.tap()
        XCTAssertTrue(signupButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        XCTAssertTrue(repeatPasswordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        XCTAssertTrue(usernameField.value != nil)
        let insertedUsername = usernameField.value as? String
        XCTAssertEqual(insertedUsername, username)
        passwordField.tap()
        passwordField.typeText(password)
        XCTAssertTrue(passwordField.value != nil)
        repeatPasswordField.tap()
        repeatPasswordField.typeText(repeatPassword)
        XCTAssertTrue(repeatPasswordField.value != nil)
        signupButton.tap()
    }
    
    func testRecover() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let recoverHyperlink = app.buttons["RecoverHyperlink"]
        let recoverButton = app.buttons["RecoverButton"]
        let mailField = app.textFields["MailField"]
        
        // Assertions
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
        continueWithEmailButton.tap()
        XCTAssertTrue(recoverHyperlink.waitForExistence(timeout: timer))
        recoverHyperlink.tap()
        XCTAssertTrue(recoverButton.waitForExistence(timeout: timer))
        XCTAssertTrue(mailField.waitForExistence(timeout: timer))
        mailField.tap()
        mailField.typeText(username)
        XCTAssertTrue(mailField.value != nil)
        let insertedUsername = mailField.value as? String
        XCTAssertEqual(insertedUsername, username)
        recoverButton.tap()
    }
}
