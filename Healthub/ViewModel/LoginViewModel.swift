//
//  LoginViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/11/22.
//

import Foundation
import SwiftKeychainWrapper

class LoginViewModel: ObservableObject {
    
    @Published
    private var hasError: Bool = false
    private var loginCompleted: Bool = false
    
    
     func doLogout(){
         UserService.shared.doLogout(){(success, error) in
             if let error = error{
                 print(error)
             }
             
         }
    }
    
    func doLogin(email: String, password: String){
        guard !email.isEmpty && !password.isEmpty else {
                return
            }

        UserService.shared.doLogin(email: email, password: password){(success, error) in
            
            if(success == true){
                UserDefaults.standard.set(true, forKey: "isLogged")
            }else{
                print("Error during login phase")
            }
            
        }
        
        
    }
    
    
}
