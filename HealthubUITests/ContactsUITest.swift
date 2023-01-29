import XCTest

final class ContactsUITest: XCTestCase {

    // Testing app target
    let app = XCUIApplication()
    let timer = 2.0
    let longTimer = 10.0
    
    // User
    let username = "testing@mail.com"
    let password = "test"
    
    override func setUpWithError() throws {
        // Setup code invocated before tests execution
        continueAfterFailure = false
        // Chooses the device orientation
        let device = XCUIDevice.shared
        device.orientation = .portrait
        // App setup
        app.launchArguments = ["testing"]
        app.launch()
        // UI Objects
        let continueWithEmail = app.buttons["ContinueWithEmailButton"]
        let loginButton = app.buttons["LoginButton"]
        let usernameField = app.textFields["UsernameField"]
        let passwordField = app.secureTextFields["PasswordField"]
        let currentDate = app.staticTexts["CurrentDate"]
        // Login
        continueWithEmail.tap()
        usernameField.tap()
        usernameField.typeText(username)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
        // ASSERTIONS
        XCTAssert(currentDate.waitForExistence(timeout: timer))
        // Navigates to the Contacts tab
        app.tabBars.buttons.element(boundBy: 2).tap()
    }
    
    func testDoctorCreation() throws {
        // UI objects
        let contactsList = app.collectionViews["ContactsList"]
        let addButton = app.buttons["AddButton"]
        let doctorsList = app.collectionViews["DoctorsList"]
        
        // ASSERTIONS
        // The contacts list is initially empty
        XCTAssertEqual(contactsList.cells.count, 0)
        // Adds a new doctor to the contacts [ Gregory House ]
        addButton.tap()
        let doctor = doctorsList.cells.element(boundBy: 0)
        doctor.tap()
        // Checks that the doctor has been inserted in the list
        XCTAssertEqual(contactsList.cells.count, 1)
    }
    
    func testDoctorDeletion() throws {
        // UI objects
        let contactsList = app.collectionViews["ContactsList"]
        let doctor = contactsList.cells.element(boundBy: 0)
        let deleteButton = doctor.buttons["DeleteButton"]
        // ASSERTIONS
        // The contacts list is initially not empty
        XCTAssertFalse(contactsList.cells.count == 0)
        // Removes the doctor
        doctor.swipeLeft()
        deleteButton.tap()
        // Checks that the doctor has been removed
        XCTAssertEqual(contactsList.cells.count, 0)
    }
}
