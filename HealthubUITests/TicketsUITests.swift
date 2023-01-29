import XCTest

final class TicketsUITests: XCTestCase {
    
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
    }
    
    override func tearDownWithError() throws {
        // Teardown code
        app.terminate()
    }
    
    func test01_TicketCreation() throws {
        
        // UI objects
        let ticketsList = app.collectionViews["TicketsList"]
        let ticketsPlaceholder = app.images["TicketsPlaceholder"]
        let bookingButton = app.buttons["BookingButton"]
        let examinationsButton = app.buttons["ExaminationsButton"]
        let examinationsList = app.collectionViews["ExaminationsList"]
        let doctorsButton = app.buttons["DoctorsButton"]
        let doctorsList = app.collectionViews["DoctorsTicketList"]
        let dateButton = app.buttons["DateButton"]
        let datePicker = app.datePickers["DayPicker"]
        let timeButton = app.buttons["TimeButton"]
        let timePicker = app.pickers["TimePicker"]
        let confirmButton = app.buttons["ConfirmButton"]
        
        // ASSERTIONS
        // The tickets list is initially empty
        XCTAssertEqual(ticketsList.cells.count, 0)
        XCTAssert(ticketsPlaceholder.isHittable)
        // Initializes the creation of a new ticket
        bookingButton.tap()
        // Selects the examination type [ Routine ]
        examinationsButton.tap()
        let selectedExamination = examinationsList.cells.element(boundBy: 0)
        selectedExamination.tap()
        XCTAssertEqual(examinationsButton.label, "Routine")
        // Chooses the doctor [ Allison Cameron ]
        doctorsButton.tap()
        sleep(5)
        let selectedDoctor = doctorsList.cells.element(boundBy: 0)
        selectedDoctor.tap()
        XCTAssertEqual(doctorsButton.label, "Allison Cameron")
        // Selects the date [ 17.02.2023 ]
        dateButton.tap()
        datePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2023")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "Febbraio")
        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "16")
        sleep(5)
        datePicker.tap()
        XCTAssertEqual(dateButton.label, "16 Febbraio 2023")
        // Select the time slot [ 14:00 ]
        sleep(10)
        timeButton.tap()
        timePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "10:00")
        timePicker.tap()
        XCTAssertEqual(timeButton.label, "10:00")
        // Finalizes the creation of a new ticket
        confirmButton.tap()
        sleep(20)
        // Checks if the ticket has been correctly generated
        XCTAssertEqual(ticketsList.cells.count, 2)
    }
    
    func test02_TicketDetails() throws {
        // UI objects
        let ticketsList = app.collectionViews["TicketsList"]
        let selectedTicket = ticketsList.cells.element(boundBy: 1)
        let sheetTitle = app.staticTexts["TicketDetailsSheet"]
        // ASSERTIONS
        selectedTicket.tap()
        XCTAssert(sheetTitle.waitForExistence(timeout: timer))
    }
    
    func test03_TicketDeletion() throws {
        // UI objects
        let ticketsList = app.collectionViews["TicketsList"]
        let targetTicket = ticketsList.cells.element(boundBy: 1)
        let deleteButton = app.buttons["TicketDeleteButton"]
        // ASSERTIONS
        XCTAssertFalse(ticketsList.cells.count == 0)
        targetTicket.swipeLeft()
        deleteButton.tap()
        XCTAssertEqual(ticketsList.cells.count, 0)
    }
}
