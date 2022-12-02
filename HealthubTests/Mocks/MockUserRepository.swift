//
//  MockUserRepository.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
import SwiftKeychainWrapper
@testable import Healthub
struct MockUserRepository: UserRepositoryProtocol{
    
    private var user = Healthub.Patient(email: "spiderman@mail.com", name: "Peter Parker", sex: .Male, dateOfBirth: Date(), fiscalCode: "PETERPARKER", height: 178, weight: 75, phone: "+39111111111")
    
    func updateInformation(user: Healthub.Patient, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
    }
    
    func getUser(completionHandler: @escaping (Healthub.Patient?, Error?) -> Void) {
        completionHandler(user, nil)
    }
    
    func registerUser() {
        //code
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
