//
//  MockContactRepository.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 12/01/23.
//

import Foundation
import SwiftKeychainWrapper
import CoreData
@testable import Healthub
class MockContactRepository: Healthub.ContactRepositoryProtocol{
    
    private(set) var contacts: [Healthub.Contact] = []
    private(set) var testAddContact = 0
    private(set) var testRemoveContact = 0
    private(set) var dbHelper: any DBHelperProtocol
    
    init(dbHelper: any DBHelperProtocol){
        self.dbHelper = dbHelper
        let entityContact = NSEntityDescription.entity(forEntityName: "Contact", in: MockDBHelper().getContext())!
        
        let contact1 = Healthub.Contact(entity: entityContact, insertInto: MockDBHelper().getContext())
        contact1.id = 1
        contact1.name = "nameA"
        contact1.address = "addressA"
        contact1.phone = "phoneA"
        contact1.email = "emailA"
        
        dbHelper.create(contact1)
        contacts.append(contact1)
        
        let contact2 = Healthub.Contact(entity: entityContact, insertInto: MockDBHelper().getContext())
        contact2.id = 2
        contact2.name = "nameB"
        contact2.address = "addressB"
        contact2.phone = "phoneB"
        contact2.email = "emailB"
        dbHelper.create(contact2)
        contacts.append(contact2)
}
    
    
    func addContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.testAddContact = doctor_id
        completionHandler(true, nil)
    }
    
    func getAll(force_reload: Bool, completionHandler: @escaping ([Healthub.Contact]?, Error?) -> Void) {
        
        completionHandler(contacts, nil)
    }
    
    func removeContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.testRemoveContact = doctor_id
        completionHandler(true, nil)
    }
    
    func getDoctorList(completionHandler: @escaping ([Healthub.Doctor]?, Error?) -> Void) {
        var doctors: [Healthub.Doctor] = []
        let entityDoctor = NSEntityDescription.entity(forEntityName: "Doctor", in: Healthub.CoreDataHelper.context)!
        
        let doctor1 = Healthub.Doctor(entity: entityDoctor, insertInto: nil)
        doctor1.id = 1
        doctor1.name = "nameA"
        doctor1.address = "addressA"
        doctor1.phone = "phoneA"
        doctor1.email = "emailA"
        
        doctors.append(doctor1)
        
        let doctor2 = Healthub.Contact(entity: entityDoctor, insertInto: nil)
        doctor2.id = 2
        doctor2.name = "nameB"
        doctor2.address = "addressB"
        doctor2.phone = "phoneB"
        doctor2.email = "emailB"
        
        doctors.append(doctor2)
        
        completionHandler(doctors, nil)
    }
    
    
}
