//
//  ContactRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
import CoreData
import SwiftKeychainWrapper

class ContactRepository: ContactRepositoryProtocol{
    
    private var client: any ClientProtocol
    private var dbHelper = CoreDataHelper.shared
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    func addContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        let body = API.Types.Request.Empty()
        
        client
            .fetch(.addContact(token: token!, doctor_id: doctor_id), method: .post, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK", nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
        
    }
    
    func getAll(force_reload: Bool, completionHandler: @escaping ([Contact]?, Error?) -> Void) {
        //get all contacts
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        if force_reload == false {
            
            let result: Result<[Contact], Error> = dbHelper.fetch(Contact.self, predicate: nil)
            
            switch result {
            case .success(let contacts):
                if contacts.isEmpty == false{
                    completionHandler(contacts, nil)
                }else{
                    client
                        .get(.getContacts(token: token!)){(result: Result<API.Types.Response.GetDoctorList, API.Types.Error>) in
                            DispatchQueue.main.async {
                                switch result{
                                case .success(let success):
                                    completionHandler(self.processDoctorList(success), nil)
                                case .failure(let failure):
                                    completionHandler(nil,failure)
                                }
                            }
                        }
                }
            case .failure(let error):
                print(error)
            }
            
        } else {
            dbHelper.deleteAllEntries(entity: "Contact")
            client
                .get(.getContacts(token: token!)){(result: Result<API.Types.Response.GetDoctorList, API.Types.Error>) in
                    DispatchQueue.main.async {
                        switch result{
                        case .success(let success):
                            completionHandler(self.processDoctorList(success), nil)
                        case .failure(let failure):
                            completionHandler(nil,failure)
                        }
                    }
                }
        }
    }
    
    func removeContact(doctor_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        let body = API.Types.Request.Empty()
        client
            .fetch(.deleteContact(token: token!, doctor_id: doctor_id), method: .delete, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK", nil)
                        let predicate = NSPredicate(
                            format: "id = %@",
                            NSNumber.init(value: doctor_id) as CVarArg)
                        
                        let result = self.dbHelper.fetchFirst(Contact.self, predicate: predicate)
                        
                    switch result{
                        case .success(let contact):
                            self.dbHelper.delete(contact!)
                        case .failure(_):
                            print("failure")
                        }
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
                
            }
    }
    
    func getDoctorList(completionHandler: @escaping ([Doctor]?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        client
            .get(.getDoctorList(token: token!)){(result: Result<API.Types.Response.GetDoctorList, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(self.processDoctorList(success), nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
    }
    
    private func processDoctorList(_ results: API.Types.Response.GetDoctorList)->[Contact]{
        var local : [Contact] = []
        
        for result in results.doctors{
            let entity = NSEntityDescription.entity(forEntityName: "Contact", in: CoreDataHelper.shared.context)!
            let doctor = Contact(entity: entity, insertInto: dbHelper.context)
            doctor.id = Int16(result.id)
            doctor.name = result.name
            doctor.address = result.address
            doctor.email = result.email
            doctor.phone = result.phone
            local.append(doctor)
        }
        
        return local
    }
    
}
