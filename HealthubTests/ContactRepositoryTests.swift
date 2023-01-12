//
//  ContactRepositoryTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
@testable import Healthub
import SwiftKeychainWrapper
final class ContactRepositoryTests: XCTestCase {
    
    private var contactRepository: Healthub.ContactRepository!
    private var mockClient: MockClientReservations!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClient = MockClientReservations()
        contactRepository = Healthub.ContactRepository(client: mockClient as! Healthub.ClientProtocol, dbHelper: MockDBHelper())
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
        let exp = expectation(description: "Test getAll contacts")
        contactRepository.getAll(force_reload : true){(contacts, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(contacts)
            XCTAssertEqual(contacts!.count, 1)
            XCTAssertEqual(contacts![0].id, 1)
            XCTAssertEqual(contacts![0].name, "Gregory House")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetContacts,1)
            }
        }
        
    }
    
    func testGetAllWithCache(){
        let exp = expectation(description: "Test getAll contacts")
        contactRepository.getAll(force_reload : false){(contacts, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(contacts)
            XCTAssertEqual(contacts!.count, 1)
            XCTAssertEqual(contacts![0].id, 1)
            XCTAssertEqual(contacts![0].name, "Gregory House")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetContacts,1)
            }
        }
        
        let exp2 = expectation(description: "Test getAll contacts with cache")
        contactRepository.getAll(force_reload : false){(contacts, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(contacts)
            XCTAssertEqual(contacts!.count, 1)
            XCTAssertEqual(contacts![0].id, 1)
            XCTAssertEqual(contacts![0].name, "Gregory House")
            exp2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetContacts,1)
            }
        }
        
    }
    
    
    func testAddContact(){
        //add reservation
        let exp = expectation(description: "Test add contact")
        
        contactRepository.addContact(doctor_id: 1){(success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddContacts,1)
                XCTAssertEqual(self.mockClient.contacts.count, 1)
                XCTAssertEqual(self.mockClient.contacts[0].id, 1)
            }
        }
    }
    
    func testAddTwoContacts(){
        //add reservation
        let exp = expectation(description: "Test add contact")
        
        contactRepository.addContact(doctor_id: 1){(success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddContacts,1)
                XCTAssertEqual(self.mockClient.contacts.count, 1)
                XCTAssertEqual(self.mockClient.contacts[0].id, 1)
            }
        }
        let exp2 = expectation(description: "Test add second contact")
        contactRepository.addContact(doctor_id: 2){(success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddContacts,2)
                XCTAssertEqual(self.mockClient.contacts.count, 2)
                XCTAssertEqual(self.mockClient.contacts[1].id, 2)
                XCTAssertEqual(self.mockClient.contacts[0].id, 1)
                
            }
        }
    }
    
    func testRemoveContactWithIdNotPresent(){
        //remove reservation
        let exp = expectation(description: "Test removing reservation")
        
        contactRepository.removeContact(doctor_id: 1){(success,error) in
            XCTAssertNotNil(error)
            XCTAssertNil(success)
            XCTAssertEqual(error?.localizedDescription, "Internal Error: No reservations")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberDeleteContacts,1)
                XCTAssertEqual(self.mockClient.contacts.count, 0)
            }
        }
        
    }
    
    func testRemoveContactCorrect(){
        let exp = expectation(description: "Test remove reservation")
        
        contactRepository.addContact(doctor_id: 1){(success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddContacts,1)
                XCTAssertEqual(self.mockClient.contacts.count, 1)
                XCTAssertEqual(self.mockClient.contacts[0].id, 1)
            }
        }
        
        let exp1 = expectation(description: "Test removing reservation")
        
        contactRepository.removeContact(doctor_id: 1){(success,error) in
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            XCTAssertNil(error)
            exp1.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberDeleteContacts,1)
                XCTAssertEqual(self.mockClient.contacts.count, 0)
            }
        }
    }
    
    func testGetDoctorList(){
        let exp = expectation(description: "Test getDoctorList")
        
        contactRepository.getDoctorList(){(doctors, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(doctors)
            XCTAssertEqual(doctors?.count, 1)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetDoctorList,1)
                XCTAssertEqual(self.mockClient.doctors.count, 1)
                XCTAssertEqual(self.mockClient.doctors[0].id, 1)
            }
        }
    }

}
