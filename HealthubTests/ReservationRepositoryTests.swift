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
    
    private var reservationsRepository: ReservationsRepository!
    private var mockClient: MockClientReservations!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClient = MockClientReservations()
        reservationsRepository = ReservationsRepository(client: mockClient)
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
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        reservationsRepository.getAll(){(reservations, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(reservations)
            XCTAssertEqual(reservations!.count, 1)
            XCTAssertEqual(reservations![0].examinationType.name, "visit")
            XCTAssertEqual(reservations![0].doctor.name, "Gregory House")
            XCTAssertEqual(reservations![0].date, formatter.date(from: "2022-11-29 11:00"))
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
    
    func testAddTwoReservation(){
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
                XCTAssertEqual(self.mockClient.reservations[0].examinationType.id, 1)
            }
        }
        let exp2 = expectation(description: "Test add second reservation")
        reservationsRepository.add(date: Date(), doctor_id: 2, examinationType: 3){(success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddReservations,2)
                XCTAssertEqual(self.mockClient.reservations.count, 2)
                XCTAssertEqual(self.mockClient.reservations[self.mockClient.reservations.count - 1].doctor.id, 2)
                XCTAssertEqual(self.mockClient.reservations[self.mockClient.reservations.count - 1].examinationType.id, 3)
            }
        }
    }
    
    func testRemoveReservation(){
        //remove reservation
    }


}
