//
//  ReservationsRepositoryTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 29/11/22.
//

import XCTest
@testable import Healthub
import SwiftKeychainWrapper

final class ReservationsRepositoryTests: XCTestCase {
    
    private var reservationsRepository: Healthub.ReservationsRepository!
    private var mockClient: MockClientReservations!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClient = MockClientReservations()
        reservationsRepository = Healthub.ReservationsRepository(client: mockClient as! Healthub.ClientProtocol, dbHelper: MockDBHelper())
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }
    
    func testGetAll(){
        let exp = expectation(description: "Test getAll reservations")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        reservationsRepository.getAll(force_reload : true){(reservations, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(reservations)
            XCTAssertEqual(reservations!.count, 1)
            XCTAssertEqual(reservations![0].examinationType.name, "visit")
            XCTAssertEqual(reservations![0].doctor.name, "Gregory House")
            XCTAssertEqual(reservations![0].date, formatter.date(from: "2022-11-29"))
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetReservations,1)
            }
        }
        
    }
    
    func testGetAllWithCache(){
        let exp = expectation(description: "Test getAll reservations")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        reservationsRepository.getAll(force_reload : false){(reservations, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(reservations)
            XCTAssertEqual(reservations!.count, 1)
            XCTAssertEqual(reservations![0].examinationType.name, "visit")
            XCTAssertEqual(reservations![0].doctor.name, "Gregory House")
            XCTAssertEqual(reservations![0].date, formatter.date(from: "2022-11-29"))
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetReservations,1)
            }
        }
        
        let exp2 = expectation(description: "Test getAll reservations")
        reservationsRepository.getAll(force_reload : false){(reservations, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(reservations)
            XCTAssertEqual(reservations!.count, 1)
            XCTAssertEqual(reservations![0].examinationType.name, "visit")
            XCTAssertEqual(reservations![0].doctor.name, "Gregory House")
            XCTAssertEqual(reservations![0].date, formatter.date(from: "2022-11-29"))
            exp2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetReservations,1)
            }
        }
        
    }
    
    func testAddReservation(){
        //add reservation
        let exp = expectation(description: "Test add reservation")
        
        reservationsRepository.add(date: Date(), doctor_id: 1, examinationType: 1){(success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddReservations,1)
                XCTAssertEqual(self.mockClient.reservations.count, 1)
                XCTAssertEqual(self.mockClient.reservations[0].doctor.id, 1)
            }
        }
    }
    
    func testRemoveReservation(){
        //remove reservation
        let exp = expectation(description: "Test removing reservation")
        
        reservationsRepository.deleteReservation(reservation_id: 1){(success,error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberDeleteReservations,1)
                XCTAssertEqual(self.mockClient.testDeleteReservationId, 1)
            }
        }
        
    }
    
    
    
    func testGetAvailableDates(){
        let exp = expectation(description: "Test getAvailableDates")
        let doctor_id = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        reservationsRepository.getAvailableDates(doctor_id: doctor_id){(dates, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(dates)
            XCTAssertEqual(dates?.count, 2)
            XCTAssertEqual(dates?[0], formatter.date(from: "2022-01-01"))
            XCTAssertEqual(dates?[1], formatter.date(from: "2022-01-02"))
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }
        }
    }
    
    func testGetAvailableSlots(){
        
        let exp = expectation(description: "test getAvailableSlots")
        let doctor_id = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        reservationsRepository.getAvailableSlots(date: formatter.date(from: "2022-01-01")!, doctor_id: doctor_id, examinationType_id: 1){(slots, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(slots)
            XCTAssertEqual(slots?.count, 4)
            XCTAssertEqual(slots?[0], "10:00")
            XCTAssertEqual(slots?[3], "15:15")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }
        }
    }
    
    func testGetDoctorByExamName(){
        let exam_name = "vaccination"
        let exp = expectation(description: "test getDoctorByExamName")
        reservationsRepository.getDoctorsByExamName(exam_name: exam_name){(doctors, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(doctors)
            XCTAssertEqual(doctors?.count, 2)
            XCTAssertEqual(doctors?[0].id, 1)
            XCTAssertEqual(doctors?[0].name, "A")
            XCTAssertEqual(doctors?[1].id, 2)
            XCTAssertEqual(doctors?[1].name, "B")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }
        }
        
    }
    
    func testGetDoctorByExamNameEmpty(){
        let exam_name = "specialist"
        let exp = expectation(description: "test getDoctorByExamName empty")
        reservationsRepository.getDoctorsByExamName(exam_name: exam_name){(doctors, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(doctors)
            XCTAssertEqual(doctors?.count, 0)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }
        }
        
    }
}
