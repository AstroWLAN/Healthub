//
//  SignupUITests.swift
//  HealthubTests
//
//  Created by Dario Crippa on 07/01/23.
//

import XCTest

final class SignupUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSignup() throws {
        
        // Test setup
        let app = XCUIApplication()
        let retrievalTimeout = 2.0
        app.launch()
        
        // UI elements
        let signupButton = app.buttons["signupButton"]
        XCTAssertTrue(signupButton.waitForExistence(timeout: retrievalTimeout))
        let signupHyperlink = app.buttons["signupHyperlink"]
        XCTAssertTrue(signupHyperlink.waitForExistence(timeout: retrievalTimeout))
        let emailField = app.textFields["emailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: retrievalTimeout))
        let passwordField = app.textFields["passwordField"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: retrievalTimeout))
        let passwordCheckField = app.textFields["passwordCheckField"]
        XCTAssertTrue(passwordCheckField.waitForExistence(timeout: retrievalTimeout))
        
        // Performs login
        signupHyperlink.tap()
        emailField.tap()
        emailField.typeText("astroTester@gmail.com")
        passwordField.tap()
        passwordField.typeText("Testing97@")
        passwordCheckField.tap()
        passwordCheckField.typeText("Testing97@")
        signupButton.tap()
        
        // Condition
        
    }
    
}
