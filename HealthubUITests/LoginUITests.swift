import XCTest
@testable import Healthub

final class LoginUITests: XCTestCase {
    
    // Defines the testing app
    let app = XCUIApplication()
    let timer = 2.0

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
        app.launch()
        
        // UI Objects
        let continueWithEmail = app.staticTexts["ContinueWithEmailButton"]
        
        // Assertions
        XCTAssertTrue(continueWithEmail.waitForExistence(timeout: timer))
        XCTAssertTrue(continueWithEmail.isHittable)
        
    }

    func testLogin() throws {
        app.launch()
        
        // User Inputs
        let username = "testingUser@gmail.com"
        let password = "SecretPassword97@"
        
        // UI Objects
        let continueWithEmail = app.staticTexts["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        
        // Assertions
        continueWithEmail.tap()
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
        app.launch()
        
        // UI Objects
        
        let signupHyperlink = app.buttons["SignupHyperlink"]
        //print(XCUIApplication().debugDescription)
        
        XCTAssertTrue(signupHyperlink.waitForExistence(timeout: timer))
        XCTAssertTrue(signupHyperlink.isHittable)
    }
  
}
