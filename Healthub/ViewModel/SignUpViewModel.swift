//
//  SignUpViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 18/11/22.
//

import Foundation
import SwiftKeychainWrapper

class SignUpViewModel : ObservableObject {
    
    
    
    func signUp(email: String, password: String){
        guard !email.isEmpty && !password.isEmpty else {
                return
            }
        
    }
    
    
}
