//
//  TicketViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub


final class TicketViewModelTests: XCTestCase {

    private var ticketViewModel: Healthub.TicketViewModel!
    private var reservationRepository: MockReservationRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        reservationRepository = MockReservationRepository()
        ticketViewModel = Healthub.TicketViewModel(reservationsRepository: reservationRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testFetchTicket(){
        ticketViewModel.fetchTickets(force_reload: true)
        XCTAssertEqual(ticketViewModel.reservations.count, 2)
        XCTAssertEqual(ticketViewModel.reservations[0].id, 1)
        XCTAssertEqual(ticketViewModel.reservations[1].id, 2)
        
    }
    
    func testFetchDoctorsByExamName(){
        let exam_name = "vaccination"
        ticketViewModel.fetchDoctorsByExamName(exam_name: exam_name)
        
        XCTAssertEqual(ticketViewModel.doctors.count, 1)
        XCTAssertEqual(ticketViewModel.doctors[0].id, 1)
        XCTAssertEqual(ticketViewModel.doctors[0].name, "A")
        XCTAssertEqual(reservationRepository.testGetDoctorByExamName, exam_name)
        
        
    }
    
    func testFetchSlots(){
        let doctor_id = 1
        let examinationType_id = 1
        let date = Date.now
        ticketViewModel.fetchSlots(doctor_id: doctor_id, examinationType_id: examinationType_id, date: date)
        
        XCTAssertEqual(reservationRepository.testFetchSlotExaminationType_id, examinationType_id)
        XCTAssertEqual(reservationRepository.testFetchSlotDoctorId, doctor_id)
        XCTAssertEqual(reservationRepository.testFetchSlotDate, date)
        XCTAssertEqual(ticketViewModel.slots.count, 3)
        XCTAssertEqual(ticketViewModel.slots[0], "10:00")
        XCTAssertEqual(ticketViewModel.slots[2], "10:30")
    }
    
    func testAddReservation(){
        let date = Date.now
        let starting_time = "10:00"
        let doctor_id = 1
        let examinationType_id = 1
        ticketViewModel.addReservation(date: date, starting_time: starting_time, doctor_id: doctor_id, examinationType_id: examinationType_id)
        XCTAssertEqual(reservationRepository.testAddReservationDate, date)
        XCTAssertEqual(reservationRepository.testAddReservationStartingTime, starting_time)
        XCTAssertEqual(reservationRepository.testAddReservationDoctorId, doctor_id)
        XCTAssertEqual(reservationRepository.testAddReservationExaminationType_id, examinationType_id)
        
    }
    
    func testDeleteReservation(){
        let reservation_id = 1
        ticketViewModel.deleteReservation(reservation_id: reservation_id)
        
        XCTAssertEqual(reservationRepository.testDeletionReservationId, reservation_id)
    }
    
    func testFetchAvailableDates(){
        let doctor_id = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        ticketViewModel.fetchAvailableDates(doctor_id: doctor_id)
        
        XCTAssertEqual(reservationRepository.testGetAvailableDateDoctorId, doctor_id)
        XCTAssertEqual(ticketViewModel.availabilities.count, 3)
        XCTAssertEqual(ticketViewModel.availabilities[0], dateFormatter.date(from: "2022-01-01"))
        XCTAssertEqual(ticketViewModel.availabilities[1], dateFormatter.date(from: "2022-01-02"))
        XCTAssertEqual(ticketViewModel.availabilities[2], dateFormatter.date(from: "2022-01-03"))
    }
}
