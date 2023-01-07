//
//  RestoreUITest.swift
//  HealthubTests
//
//  Created by Dario Crippa on 07/01/23.
//

import XCTest

final class RestoreUITest: XCTestCase {

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
        let continueButton = app.buttons["continueWithEmailButton"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: retrievalTimeout))
        let restoreButton = app.buttons["restoreButton"]
        XCTAssertTrue(restoreButton.waitForExistence(timeout: retrievalTimeout))
        let restoreHyperlink = app.buttons["restoreHyperlink"]
        XCTAssertTrue(restoreHyperlink.waitForExistence(timeout: retrievalTimeout))
        let emailField = app.textFields["emailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: retrievalTimeout))
        
        // Performs login
        continueButton.tap()
        restoreHyperlink.tap()
        emailField.tap()
        emailField.typeText("astroTester@gmail.com")
        restoreButton.tap()
        
        // Condition
        
    }
    
}
