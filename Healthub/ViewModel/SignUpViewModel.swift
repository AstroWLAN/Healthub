//
//  SignUpViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 18/11/22.
//

import Foundation
import SwiftKeychainWrapper

class SignUpViewModel : ObservableObject {
    
    private var userRepository: any UserRepositoryProtocol
    @Published private(set) var errorType: String?
    @Published var userCreated: Bool = false
    
    init(userRepository: any UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func signUp(email: String, password: String){
        guard !email.isEmpty && !password.isEmpty else {
                return
            }
        userRepository.registerUser(email: email, password: password){(success, error) in
            if let error = error{
                self.errorType = error.errorDescription
            }else{
                if let success = success{
                    if success == true{
                        //UserDefaults.standard.set(true, forKey: "isLogged")
                        self.userCreated = true
                    }
                }
            }
            
        }
    }
    
    
}
