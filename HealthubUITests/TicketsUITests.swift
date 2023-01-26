//
//  TicketsUITests.swift
//  HealthubUITests
//
//  Created by Dario Crippa on 20/01/23.
//

import XCTest

final class TicketsUITests: XCTestCase {
    
    let app = XCUIApplication()
    let timer = 2.0
    let longTimer = 10.0

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTicketCreation() throws {
        
        app.launchArguments = ["testing"]
        app.launch()

        // User Inputs
        let username = "testing@mail.com"
        let password = "test"
        
        // UI Objects
        let continueWithEmail = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let currentDate = app.staticTexts["CurrentDate"]
        let ticketsList = app.collectionViews["TicketsList"]
        let ticket = ticketsList.cells.element(boundBy: 0)
        
        // Login
        continueWithEmail.tap()
        XCTAssertTrue(loginButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        
        // Navigates to the Profile Tab
        XCTAssertTrue(currentDate.waitForExistence(timeout: longTimer))
        XCTAssertTrue(ticketsList.waitForExistence(timeout: timer))
        XCTAssertTrue(ticket.waitForExistence(timeout: timer))
    }
}
