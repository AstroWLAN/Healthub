//
//  ProfileUITests.swift
//  HealthubUITests
//
//  Created by Dario Crippa on 23/01/23.
//

import XCTest

final class ProfileUITests: XCTestCase {
    
    let app = XCUIApplication()
    let timer = 2.0
    let longTimer = 10.0
    let user = "Tester"
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
    }

    func testProfile() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let profileTab = app.tabBars.buttons.element(boundBy: 3)
        let profileList = app.collectionViews["ProfileList"]
        let nameField = app.textFields["NameField"]
        let codeField = app.textFields["CodeField"]
        let phoneField = app.textFields["PhoneField"]
        
        // ASSERTIONS
        // Login
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
        continueWithEmailButton.tap()
        XCTAssertTrue(loginButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        // Profile
        XCTAssertTrue(profileTab.waitForExistence(timeout: longTimer))
        profileTab.tap()
        XCTAssertTrue(profileList.waitForExistence(timeout: timer))
        XCTAssertTrue(nameField.waitForExistence(timeout: timer))
        XCTAssertTrue(codeField.waitForExistence(timeout: timer))
        XCTAssertTrue(phoneField.waitForExistence(timeout: timer))
    }
    
    func testPathologies() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let profileTab = app.tabBars.buttons.element(boundBy: 3)
        let pathologies = app.buttons["Pathologies"]
        
        // ASSERTIONS
        // Login
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
        continueWithEmailButton.tap()
        XCTAssertTrue(loginButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        // Profile
        XCTAssertTrue(profileTab.waitForExistence(timeout: longTimer))
        profileTab.tap()
        XCTAssertTrue(pathologies.waitForExistence(timeout: longTimer))
        pathologies.tap()
    }
    
    func testInformation() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let profileTab = app.tabBars.buttons.element(boundBy: 3)
        let information = app.buttons["Information"]
        let robotDraw = app.images["RobotDraw"]
        
        // ASSERTIONS
        // Login
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
        continueWithEmailButton.tap()
        XCTAssertTrue(loginButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        // Profile
        XCTAssertTrue(profileTab.waitForExistence(timeout: longTimer))
        profileTab.tap()
        XCTAssertTrue(information.waitForExistence(timeout: timer))
        information.tap()
        // Information
        XCTAssertTrue(robotDraw.waitForExistence(timeout: timer))
    }
    
    func testSignOut() throws {
        app.launchArguments = ["testing"]
        app.launch()
        
        // UI Objects
        let continueWithEmailButton = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let profileTab = app.tabBars.buttons.element(boundBy: 3)
        let signOut = app.buttons["SignOut"]
        
        // ASSERTIONS
        // Login
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: timer))
        continueWithEmailButton.tap()
        XCTAssertTrue(loginButton.waitForExistence(timeout: timer))
        XCTAssertTrue(usernameField.waitForExistence(timeout: timer))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timer))
        usernameField.tap()
        usernameField.typeText(username)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        // Profile
        XCTAssertTrue(profileTab.waitForExistence(timeout: longTimer))
        profileTab.tap()
        XCTAssertTrue(signOut.waitForExistence(timeout: timer))
        signOut.tap()
        XCTAssertTrue(continueWithEmailButton.waitForExistence(timeout: longTimer))
    }
}
