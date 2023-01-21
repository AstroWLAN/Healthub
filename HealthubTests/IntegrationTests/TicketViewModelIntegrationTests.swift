//
//  TicketViewModelIntegrationTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub


final class TicketViewModelIntegrationTests: XCTestCase {

    private var ticketViewModel: Healthub.TicketViewModel!
    private var reservationRepository: Healthub.ReservationsRepository!
    private var clientAPI: MockClientReservations!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
        
        clientAPI = MockClientReservations()
        reservationRepository = Healthub.ReservationsRepository(client: clientAPI, dbHelper: MockDBHelper())
        ticketViewModel = Healthub.TicketViewModel(reservationsRepository: reservationRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }


    func testFetchTicket(){
        
        let expectation = XCTestExpectation(description: "Object's property should change")
        ticketViewModel.fetchTickets(force_reload: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.ticketViewModel.reservations.count, 1)
            XCTAssertEqual(self.ticketViewModel.reservations[0].id, 1)
            XCTAssertEqual(self.ticketViewModel.reservations[0].doctor.name, "Gregory House")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
        
    }
    
    func testFetchDoctorsByExamName(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        let exam_name = "vaccination"
        ticketViewModel.fetchDoctorsByExamName(exam_name: exam_name)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.ticketViewModel.doctors.count, 2)
            XCTAssertEqual(self.ticketViewModel.doctors[0].id, 1)
            XCTAssertEqual(self.ticketViewModel.doctors[0].name, "A")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
        
        
        
    }
    
    func testFetchSlots(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        let doctor_id = 1
        let examinationType_id = 1
        let date = Date.now
        ticketViewModel.fetchSlots(doctor_id: doctor_id, examinationType_id: examinationType_id, date: date)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.ticketViewModel.slots.count, 4)
            XCTAssertEqual(self.ticketViewModel.slots[0], "10:00")
            XCTAssertEqual(self.ticketViewModel.slots[1], "10:15")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
        
    }
    
    func testAddReservation(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        let date = Date.now
        let starting_time = "10:00"
        let doctor_id = 1
        let examinationType_id = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        ticketViewModel.addReservation(date: date, starting_time: starting_time, doctor_id: doctor_id, examinationType_id: examinationType_id)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.reservations[0].date, dateFormatter.string(from: date))
            XCTAssertEqual(self.clientAPI.reservations[0].doctor.id, doctor_id)
            XCTAssertEqual(self.clientAPI.reservations[0].examinationType.id, examinationType_id)
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testDeleteReservation(){
        let expectation2 = XCTestExpectation(description: "Object's property should change")
        let reservation_id = 1
        ticketViewModel.deleteReservation(reservation_id: reservation_id)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.testDeleteReservationId, reservation_id)
            expectation2.fulfill()
            }
       
        wait(for: [expectation2], timeout: 1.0)
        
       
    }
    
    func testFetchAvailableDates(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        let doctor_id = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        ticketViewModel.fetchAvailableDates(doctor_id: doctor_id)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.ticketViewModel.availabilities.count, 2)
            XCTAssertEqual(self.ticketViewModel.availabilities[0].formatted(.dateTime.day().month().day()), dateFormatter.date(from: "2022-01-01")!.formatted(.dateTime.day().month().day()))
            XCTAssertEqual(self.ticketViewModel.availabilities[1].formatted(.dateTime.day().month().day()), dateFormatter.date(from: "2022-01-02")!.formatted(.dateTime.day().month().day()))
            
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
    }
}
