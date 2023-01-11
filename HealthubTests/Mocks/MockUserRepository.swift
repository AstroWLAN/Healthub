//
//  MockUserRepository.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
import SwiftKeychainWrapper
import CoreData
@testable import Healthub
struct MockUserRepository: Healthub.UserRepositoryProtocol{
    
    
    private var user: Healthub.Patient
    
    init(){
        let entity = NSEntityDescription.entity(forEntityName: "Patient", in: Healthub.CoreDataHelper.context)!
        user = Healthub.Patient(entity: entity, insertInto: nil)
        user.email = "spiderman@mail.com"
        user.name = "Peter Parker"
        user.sex = 0
        user.dateOfBirth = Date()
        user.fiscalCode = "PETERPARKER"
        user.height = 178
        user.weight = 75
        user.phone = "+39111111111"
    }
    
    func updateInformation(user: Healthub.Patient, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
    }
    
    func getUser(force_reload: Bool = false, completionHandler: @escaping (Healthub.Patient?, Error?) -> Void) {
        completionHandler(user, nil)
    }
    
    func registerUser(email: String, password: String, completionHandler: @escaping (Bool?, Healthub.API.Types.Error?) -> Void) {
        //code
    }
    
    func recover(email: String, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //recover
    }
    
    func doLogin(email: String, password: String, completionHandler: @escaping (Bool?, Healthub.API.Types.Error?) -> Void) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        completionHandler(true, nil)
    }
    
    func doLogout(completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        
        guard removeSuccessful == true else{
            preconditionFailure("unable to remove access_token")
        }
        UserDefaults.standard.set(false, forKey: "isLogged")
        
        completionHandler(true, nil)
    }
    
    
}
