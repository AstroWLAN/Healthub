//
//  ContactViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class ContactViewModelTests: XCTestCase {
    
    private var contactViewModel: Healthub.ContactViewModel!
    private var contactRepository: MockContactRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        contactRepository = MockContactRepository()
        contactViewModel = Healthub.ContactViewModel(contactRepository: contactRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetDoctorList(){
        contactViewModel.getDoctorList()
        XCTAssertEqual(contactViewModel.doctors.count, 2)
        XCTAssertEqual(contactViewModel.doctors[0].id, 1)
        XCTAssertEqual(contactViewModel.doctors[0].name, "nameA")
        XCTAssertEqual(contactViewModel.doctors[1].id, 2)
        XCTAssertEqual(contactViewModel.doctors[1].name, "nameB")
    }
    
    func testFetchContacts(){
        contactViewModel.fetchContacts(force_reload: true)
        
        XCTAssertEqual(contactViewModel.contacts.count, 2)
        XCTAssertEqual(contactViewModel.contacts[0].id, 1)
        XCTAssertEqual(contactViewModel.contacts[0].name, "nameA")
        XCTAssertEqual(contactViewModel.contacts[1].id, 2)
        XCTAssertEqual(contactViewModel.contacts[1].name, "nameB")
        
    }
    
    func testDeleteContact(){
        let doctor_id = 1
        contactViewModel.deleteContact(doctor_id: doctor_id)
        
        XCTAssertEqual(contactRepository.testRemoveContact, doctor_id)
    }
    
    func testAddContact(){
        let doctor_id = 1
        contactViewModel.addContact(doctor_id: doctor_id)
        
        XCTAssertEqual(contactRepository.testAddContact, doctor_id)
    }

}
