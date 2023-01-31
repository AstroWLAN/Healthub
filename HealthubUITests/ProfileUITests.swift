import XCTest

final class ProfileUITests: XCTestCase {
    
    // Testing app target
    let app = XCUIApplication()
    let timer = 5.0
    let longTimer = 10.0
    
    // User
    let username = "testing@mail.com"
    let password = "test"
    let pathologyName = "Malaria"
    
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
        app.tabBars.buttons.element(boundBy: 3).tap()
    }
    
    override func tearDownWithError() throws {
        // Teardown code
        app.terminate()
    }
    
    func test01_PathologiesCreation() throws {
        // UI objects
        let returnKey = app.keyboards.buttons["Return"]
        let pathologyButton = app.buttons["Profile_PathologiesButton"]
        let pathologyTextfield = app.textFields["PathologyField"]
        let pathologiesList = app.collectionViews["PathologiesList"]
        
        // ASSERTIONS
        // Initially the pathologies list is empty
        pathologyButton.tap()
        XCTAssertEqual(pathologiesList.cells.count, 1)
        // Inserts a new pathology
        pathologyTextfield.tap()
        pathologyTextfield.typeText(pathologyName)
        returnKey.tap()
        // Checks if the pathology has been correctly inserted
        XCTAssertEqual(pathologiesList.cells.count, 2)
    }
    
    func test02_PathologiesDeletion() throws {
        // UI objects
        let pathologyButton = app.buttons["Profile_PathologiesButton"]
        let pathologiesList = app.collectionViews["PathologiesList"]
        let targetPathology = pathologiesList.cells.element(boundBy: 1)
        let deleteButton = app.buttons["DeletePathologyButton"]
        
        // ASSERTIONS
        // Initially the pathologies list is not empty
        pathologyButton.tap()
        XCTAssertFalse(pathologiesList.cells.count == 0)
        // Deletes the pathology
        targetPathology.swipeLeft()
        deleteButton.tap()
        // Checks if the pathology has been correctly deleted
        XCTAssertEqual(pathologiesList.cells.count, 1)
    }
    
    func test03_Profile() throws {
        let profileList = app.collectionViews["ProfileList"]
        let genderButton = app.buttons["Profile_GenderButton"]
        let genderPicker = app.pickers["Shared_GenderPicker"]
        let heightButton = app.buttons["Profile_HeightButton"]
        let heightPicker = app.pickers["Shared_HeightPicker"]
        let weightButton = app.buttons["Profile_WeightButton"]
        let weightPicker = app.pickers["Shared_WeightPicker"]
        let birthdayButton = app.buttons["Profile_BirthdayButton"]
        let birthdayPicker = app.datePickers["Shared_BirthdayPicker"]
        
        // ASSERTIONS
        // Checks if the list of user information exists
        XCTAssert(profileList.exists)
        // Checks if all the pickers are reachable
        genderButton.tap()
        XCTAssert(genderPicker.isHittable)
        genderPicker.tap()
        heightButton.tap()
        XCTAssert(heightPicker.isHittable)
        heightPicker.tap()
        weightButton.tap()
        XCTAssert(weightPicker.isHittable)
        weightPicker.tap()
        birthdayButton.tap()
        XCTAssert(birthdayPicker.isHittable)
        birthdayPicker.tap()
    }
    
}
