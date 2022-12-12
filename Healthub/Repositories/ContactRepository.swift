//
//  ContactRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

class ContactRepository: ContactRepositoryProtocol{
    
    private var client: any ClientProtocol
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    func addContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //add contact
    }
    
    func getAll(completionHandler: @escaping ([Doctor]?, Error?) -> Void) {
        //get all contacts
    }
    
    func removeContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //remove contact
    }
    
    
}
