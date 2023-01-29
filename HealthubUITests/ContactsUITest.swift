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
    
    override func tearDownWithError() throws {
        // Teardown code
        app.terminate()
    }
    
    func test01_DoctorCreation() throws {
        // UI objects
        let contactsList = app.collectionViews["ContactsList"]
        let addButton = app.buttons["AddDoctorButton"]
        let doctorsList = app.collectionViews["DoctorsContactsList"]
        
        // ASSERTIONS
        // Cleans possibile previous doctor
        if contactsList.cells.count > 0 {
            let doctor = contactsList.cells.element(boundBy: 1)
            let deleteButton = app.buttons["DeleteDoctorButton"]
            XCTAssertEqual(contactsList.cells.count, 2)
            doctor.swipeLeft()
            deleteButton.tap()
            // Checks that the doctor has been removed
            XCTAssertEqual(contactsList.cells.count, 0)
        }
        // The contacts list is initially empty
        XCTAssertEqual(contactsList.cells.count, 0)
        // Adds a new doctor to the contacts [ Gregory House ]
        addButton.tap()
        sleep(10)
        let doctor = doctorsList.cells.element(boundBy: 1)
        doctor.tap()
        // Checks that the doctor has been inserted in the list
        XCTAssertEqual(contactsList.cells.count, 2)
    }
    
    func test02_DoctorDeletion() throws {
        // UI objects
        let contactsList = app.collectionViews["ContactsList"]
        let doctor = contactsList.cells.element(boundBy: 1)
        let deleteButton = app.buttons["DeleteDoctorButton"]
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
