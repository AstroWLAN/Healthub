//
//  ContactViewModelIntegrationTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class ContactViewModelIntegrationTests: XCTestCase {
    
    private var contactViewModel: Healthub.ContactViewModel!
    private var contactRepository: ContactRepository!
    private var clientAPI: MockClientReservations!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
        clientAPI = MockClientReservations()
        contactRepository = ContactRepository(client: clientAPI, dbHelper: MockDBHelper())
        contactViewModel = Healthub.ContactViewModel(contactRepository: contactRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }

    func testGetDoctorList(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        contactViewModel.getDoctorList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.contactViewModel.doctors.count, 1)
            XCTAssertEqual(self.contactViewModel.doctors[0].id, 1)
            XCTAssertEqual(self.contactViewModel.doctors[0].name, "Gregory House")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
       
       
    }
    
    func testFetchContacts(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        contactViewModel.fetchContacts(force_reload: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.contactViewModel.contacts.count, 1)
            XCTAssertEqual(self.contactViewModel.contacts[0].id, 1)
            XCTAssertEqual(self.contactViewModel.contacts[0].name, "Gregory House")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
        
    }
    
    
   
    
    func testDeleteContact(){
        let expectation2 = XCTestExpectation(description: "Object's property should change")
        let doctor_id = 1
        contactViewModel.deleteContact(doctor_id: doctor_id)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.numberDeleteContacts, 1)
            XCTAssertEqual(self.clientAPI.testDeleteContactDoctorId, doctor_id)
            expectation2.fulfill()
            }
       
        wait(for: [expectation2], timeout: 1.0)
        
    }
    
    func testAddContact(){
        let doctor_id = 1
        contactViewModel.addContact(doctor_id: doctor_id)
        let expectation = XCTestExpectation(description: "Object's property should change")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.numberAddContacts, 1)
            XCTAssertEqual(self.clientAPI.testAddContactDoctorId, doctor_id)
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 5.0)
        
    }

}
