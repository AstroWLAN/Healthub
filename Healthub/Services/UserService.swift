//
//  UserService.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import SwiftKeychainWrapper

class UserService{
    
    public static let shared = UserService()
    
    private init(){}
    
    func registerUser(){
        //register user
    }
    
    func doLogin(email: String, password: String, completionHandler: @escaping (Bool?, Error?) -> Void){
        //perform login
        let body = API.Types.Request.Empty()
        API.Client.shared
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
        API.Client.shared
            .fetch(.logout(token: token!), method:.post, body: body ){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        if(success.status == "OK"){
                            let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
                            if removeSuccessful == true{
                                UserDefaults.standard.set(false, forKey: "isLogged")
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
