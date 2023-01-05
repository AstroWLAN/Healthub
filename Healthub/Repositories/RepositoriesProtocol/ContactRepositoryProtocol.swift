//
//  ContactRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

protocol ContactRepositoryProtocol {
    func addContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getAll(force_reload: Bool, completionHandler: @escaping ([Contact]?, Error?) -> Void)
    func removeContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getDoctorList(completionHandler: @escaping ([Doctor]?, Error?) -> Void)
    
}
