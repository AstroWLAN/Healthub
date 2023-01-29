import XCTest

final class TherapiesUITests: XCTestCase {

    // Testing app target
    let app = XCUIApplication()
    let timer = 2.0
    let longTimer = 10.0
    
    // User inputs
    let prescriptionTitle = "Test"
    let prescriptionDuration = "Lifetime"
    let prescriptionDrug = "Acido"
    
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
    
    func test01_TherapyCreation() throws {
        // UI objects
        let returnKey = app.keyboards.buttons["Return"]
        let therapiesList = app.collectionViews["TherapiesList"]
        let prescriptionButton = app.buttons["AddPrescriptionButton"]
        let nameTextfield = app.textFields["TherapyNameTextfield"]
        let durationTextfield = app.textFields["TherapyDurationTextfield"]
        let notesButton = app.buttons["NotesButton"]
        let notesConfirm = app.buttons["NotesConfirm"]
        let drugsDatabase = app.buttons["DrugsDatabase"]
        let searchDrugTextfield = app.textFields["SearchDrugTextfield"]
        let drugsList = app.collectionViews["ResultDrugsList"]
        let drugsConfirmButton = app.buttons["DrugsConfirmButton"]
        let confirmButton = app.buttons["PrescriptionCreationButton"]
        // ASSERTIONS
        // Initially the therapies list is empty
        XCTAssertEqual(therapiesList.cells.count, 0)
        // Creates a new therapy
        prescriptionButton.tap()
        nameTextfield.tap()
        nameTextfield.typeText(prescriptionDrug)
        durationTextfield.tap()
        durationTextfield.typeText(prescriptionDuration)
        notesButton.tap()
        notesConfirm.tap()
        drugsDatabase.tap()
        searchDrugTextfield.tap()
        searchDrugTextfield.typeText(prescriptionDrug)
        returnKey.tap()
        sleep(10)
        let selectedDrug = drugsList.cells.element(boundBy: 1)
        selectedDrug.tap()
        drugsConfirmButton.tap()
        XCTAssert(confirmButton.isEnabled)
        confirmButton.tap()
        sleep(20)
        // Checks if the therapy has been successfully created
        XCTAssertEqual(therapiesList.cells.count, 2)
    }
    
    func test02_TherapyDetails() throws {
        // UI objects
        let therapiesList = app.collectionViews["TherapiesList"]
        let selectedTherapy = therapiesList.cells.element(boundBy: 1)
        let sheetTitle = app.staticTexts["TherapySheetTitle"]
        // ASSERTIONS
        // Expands the details of the selected therapy
        selectedTherapy.tap()
        XCTAssert(sheetTitle.waitForExistence(timeout: timer))
    }
    
    func test03_TherapyDeletion() throws {
        // UI objects
        let therapiesList = app.collectionViews["TherapiesList"]
        let targetTherapy = therapiesList.cells.element(boundBy: 1)
        let deleteButton = app.buttons["DeleteTherapyButton"]
        // ASSERTIONS
        XCTAssertFalse(therapiesList.cells.count == 0)
        targetTherapy.swipeLeft()
        deleteButton.tap()
        XCTAssertEqual(therapiesList.cells.count, 0)
    }
}
