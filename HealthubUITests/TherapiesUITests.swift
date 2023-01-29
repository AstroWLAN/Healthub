import XCTest

final class TherapiesUITests: XCTestCase {

    // Testing app target
    let app = XCUIApplication()
    let timer = 2.0
    let longTimer = 10.0
    let title = "TerapiaTest"
    let duration = "Lifetime"
    let drugname = "Acido"
    
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
        // Navigates to the Therapies tab
        app.tabBars.buttons.element(boundBy: 1).tap()
    }
    
    override func tearDownWithError() throws {
        // Teardown code
        app.terminate()
    }
    
    func testTherapyCreation() throws {
        // UI objects
        let therapiesList = app.collectionViews["TherapiesList"]
        let prescriptionButton = app.buttons["PrescriptionButton"]
        let nameTextfield = app.textFields["TherapyNameTextfield"]
        let durationTextfield = app.textFields["TherapyDurationTextfield"]
        let drugsDatabase = app.buttons["DrugsDatabase"]
        let searchDrugTextfield = app.textFields["SearchDrugTextfield"]
        let drugsList = app.collectionViews["QueryDrugsList"]
        let confirmButton = app.buttons["PrescriptionCreationButton"]
        // ASSERTIONS
        // Initially the therapies list is empty
        XCTAssertEqual(therapiesList.cells.count, 0)
        // Creates a new therapy
        prescriptionButton.tap()
        nameTextfield.tap()
        nameTextfield.typeText(title)
        durationTextfield.tap()
        durationTextfield.typeText(duration)
        drugsDatabase.tap()
        searchDrugTextfield.tap()
        searchDrugTextfield.typeText(drugname)
        let selectedDrug = drugsList.cells.element(boundBy: 0)
        selectedDrug.tap()
        XCTAssert(prescriptionButton.isEnabled)
        prescriptionButton.tap()
        sleep(20)
        // Checks if the therapy has been successfully created
        XCTAssertEqual(therapiesList.cells.count, 1)
        XCTAssertEqual(therapiesList.cells.element(boundBy: 0).label, title)
    }
    
    func testTherapyDetails() throws {
        // UI objects
        let therapiesList = app.collectionViews["TherapiesList"]
        let selectedTherapy = therapiesList.cells.element(boundBy: 0)
        let sheetTitle = app.staticTexts["TherapySheetTitle"]
        // ASSERTIONS
        // Expands the details of the selected therapy
        selectedTherapy.tap()
        XCTAssert(sheetTitle.waitForExistence(timeout: timer))
        
    }
    
    func testTherapyDeletion() throws {
        // UI objects
        let therapiesList = app.collectionViews["TherapiesList"]
        let targetTherapy = therapiesList.cells.element(boundBy: 0)
        let deleteButton = targetTherapy.buttons["DeleteTherapyButton"]
        // ASSERTIONS
        XCTAssertFalse(therapiesList.cells.count == 0)
        targetTherapy.swipeLeft()
        deleteButton.tap()
        XCTAssertEqual(therapiesList.cells.count, 0)
    }
}
