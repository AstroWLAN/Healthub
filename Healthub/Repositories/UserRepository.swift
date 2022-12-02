//
//  UserService.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import SwiftKeychainWrapper

class UserRepository: UserRepositoryProtocol{
    
    
    private var client: any ClientProtocol
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    
    func updateInformation(user: Patient, completionHandler: @escaping (Bool?, Error?) -> Void){
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        
        let sex = API.GenderTranslation.gender_r["\(user.sex)".lowercased()]
        
        let body = API.Types.Request.UpdatePatient(name: user.name, sex: sex!, dateOfBirth: df.string(from:user.dateOfBirth), fiscalCode: user.fiscalCode, height: user.height, weight: user.weight, phone: user.phone)
        
        client.fetch(.updatePatient(token: token!), method:.put, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
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
    
    func getUser(completionHandler: @escaping (Patient?, Error?) -> Void){
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"

        let token = KeychainWrapper.standard.string(forKey: "access_token")
        client
            .get(.getPatient(token: token!)){ (result: Result<API.Types.Response.GetPatient, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        let sex = Genders(rawValue: API.GenderTranslation.gender[success.sex]! )
                        let patient = Patient(email: success.email,
                                              name: success.name, sex: sex! , dateOfBirth: df.date(from: success.dateOfBirth)!, fiscalCode: success.fiscalCode, height: success.height, weight: success.weight, phone: success.phone)
                         completionHandler(patient, nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            
        }
    }
    
    func registerUser(){
        //register user
    }
    
    func doLogin(email: String, password: String, completionHandler: @escaping (Bool?, API.Types.Error?) -> Void){
        //perform login
        let body = API.Types.Request.Empty()
        client
            .fetch(.login(email: email, password: password), method:.post, body: body ){(result: Result<API.Types.Response.UserLogin, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        let saveSuccessful: Bool = KeychainWrapper.standard.set(success.access_token, forKey: "access_token")
                        completionHandler(success.access_token != "" && saveSuccessful == true, nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
        
    }
    
    func doLogout(completionHandler: @escaping (Bool?, Error?) -> Void){
        //perform logout
        //TODO: Add logout also on server by destroying the token
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        
        let body = API.Types.Request.Empty()
        client
            .fetch(.logout(token: token!), method:.post, body: body ){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        if(success.status == "OK"){
                            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
                            if removeSuccessful == true{
                                UserDefaults.standard.set(false, forKey: "isLogged")
                                UserDefaults.standard.synchronize()
                                completionHandler(true, nil)
                            }
                            else{
                                completionHandler(nil, API.Types.Error.generic(reason: "Unable to perform logout"))
                            }
                        }else{
                            completionHandler(nil, API.Types.Error.generic(reason: "Unable to perform logout"))
                        }
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
        
        
            
    }
    
}
