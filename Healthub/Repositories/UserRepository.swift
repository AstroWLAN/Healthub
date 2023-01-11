//
//  UserService.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import SwiftKeychainWrapper
import CoreData

class UserRepository: UserRepositoryProtocol{
    
    
    private var client: any ClientProtocol
    private var dbHelper: any DBHelperProtocol
    
    init(client: any ClientProtocol, dbHelper: any DBHelperProtocol) {
        self.client = client
        self.dbHelper = dbHelper
    }
    
    
    func updateInformation(user: Patient, completionHandler: @escaping (Bool?, Error?) -> Void){
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        
        let sex = Int(user.sex)
        
        let body = API.Types.Request.UpdatePatient(name: user.name, sex: sex, dateOfBirth: df.string(from:user.dateOfBirth), fiscalCode: user.fiscalCode, height: Int(user.height), weight: user.weight, phone: user.phone)
        
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
    
    func getUser(force_reload: Bool = false, completionHandler: @escaping (Patient?, Error?) -> Void){
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"

        let token = KeychainWrapper.standard.string(forKey: "access_token")
        
        if force_reload == false {
            let result =  dbHelper.fetch(Patient.self, predicate: nil, limit: nil)
            
            switch result {
            case .success(let patient):
                if patient.isEmpty == false{
                    completionHandler((patient as! [Patient])[0], nil)
                }else{
                    client
                        .get(.getPatient(token: token!)){ (result: Result<API.Types.Response.GetPatient, API.Types.Error>) in
                            DispatchQueue.main.async {
                                switch result{
                                case .success(let success):
                                    let sex = Gender(rawValue: API.GenderTranslation.gender[success.sex]! )
                                    let patient = Patient(entity: NSEntityDescription.entity(forEntityName: "Patient", in: self.dbHelper.getContext())!, insertInto: self.dbHelper.getContext())
                                    patient.email = success.email
                                    patient.name = success.name
                                    patient.sex = Int16(Gender.index(of: sex!))
                                    patient.dateOfBirth = df.date(from: success.dateOfBirth)!
                                    patient.fiscalCode = success.fiscalCode
                                    patient.height = Int16(success.height)
                                    patient.weight = success.weight
                                    patient.phone = success.phone
                                    
                                    completionHandler(patient, nil)
                                case .failure(let failure):
                                    completionHandler(nil,failure)
                                }
                            }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }else{
            dbHelper.deleteAllEntries(entity: "Patient")
            client
                .get(.getPatient(token: token!)){ (result: Result<API.Types.Response.GetPatient, API.Types.Error>) in
                    DispatchQueue.main.async {
                        switch result{
                        case .success(let success):
                            let sex = Gender(rawValue: API.GenderTranslation.gender[success.sex]! )
                            let patient = Patient(entity:NSEntityDescription.entity(forEntityName: "Patient", in: self.dbHelper.getContext())!, insertInto: self.dbHelper.getContext())
                            patient.email = success.email
                            patient.name = success.name
                            patient.sex = Int16(Gender.index(of: sex!))
                            patient.dateOfBirth = df.date(from: success.dateOfBirth)!
                            patient.fiscalCode = success.fiscalCode
                            patient.height = Int16(success.height)
                            patient.weight = success.weight
                            patient.phone = success.phone
                            
                            completionHandler(patient, nil)
                        case .failure(let failure):
                            completionHandler(nil,failure)
                        }
                    }
            }
        }
        
    }
    
    func registerUser(email: String, password: String, completionHandler: @escaping (Bool?, API.Types.Error?) -> Void){
        
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        
        
        let body = API.Types.Request.CreatePatient(email: email, password: password, name: "", sex: 0, dateOfBirth: df.string(from: Date()), fiscalCode: "", height: 0, weight: 0, phone: "")
        
        
        client.fetch(.createPatient, method:.post, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let success):
                    if success.status == "OK"{
                        completionHandler(true , nil)
                    }else{
                        completionHandler(nil, API.Types.Error.inter(reason: success.problem!) )
                    }
                case .failure(let failure):
                    completionHandler(nil,failure)
                }
            }
        }
        
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
    
    func recover(email: String, completionHandler: @escaping (Bool?, Error?) -> Void){
        let body = API.Types.Request.Empty()
        client
            .fetch(.resetPassword(email: email), method: .post, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
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
    
    func doLogout(completionHandler: @escaping (Bool?, Error?) -> Void){
        //perform logout
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        let body = API.Types.Request.Empty()
        client
            .fetch(.logout(token: token!), method:.post, body: body ){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        if(success.status == "OK"){
                            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
                            if removeSuccessful == true{
                                self.dbHelper.deleteAllEntries(entity: "Patient")
                                self.dbHelper.deleteAllEntries(entity: "Pathology")
                                self.dbHelper.deleteAllEntries(entity: "Reservation")
                                self.dbHelper.deleteAllEntries(entity: "Therapy")
                                self.dbHelper.deleteAllEntries(entity: "Doctor")
                                self.dbHelper.deleteAllEntries(entity: "Drug")
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
