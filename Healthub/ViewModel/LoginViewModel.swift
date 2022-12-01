//
//  LoginViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/11/22.
//

import Foundation
import SwiftKeychainWrapper

class LoginViewModel: ObservableObject {
    
    @Published var hasError: Bool = false
    private var loginCompleted: Bool = false
    private var userService: UserRepository
    
    init(userService: UserRepository) {
        self.userService = userService
    }
    
     func doLogout(){
         userService.doLogout(){(success, error) in
             if let error = error{
                 print(error)
             }
             
         }
    }
    
    func doLogin(email: String, password: String){
        guard !email.isEmpty && !password.isEmpty else {
                return
            }
        hasError = false

        userService.doLogin(email: email, password: password){(success, error) in
            
            if(success == true){
                UserDefaults.standard.set(true, forKey: "isLogged")
            }else{
                if let error = error{
                    switch error{
                    case .generic(reason: _):
                        print(error)
                    case .server(reason: _):
                        print(error)
                    case .unauthorized(reason: _):
                        self.hasError = true
                    case .inter(reason: _):
                        print(error)
                    case .loginError(reason: _):
                        print(error)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
}
