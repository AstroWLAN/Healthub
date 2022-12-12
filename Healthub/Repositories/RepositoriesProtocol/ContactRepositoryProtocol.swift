//
//  ContactRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

protocol ContactRepositoryProtocol {
    func addContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getAll(completionHandler: @escaping ([Doctor]?, Error?) -> Void)
    func removeContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    
}
