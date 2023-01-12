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
    @Published private(set) var errorType: String = ""
    @Published var userCreated: Bool = false
    @Published var errorSignUp: Bool = false
    @Published var notificationErrorSignUp: Bool = false
    
    init(userRepository: any UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func recover(email: String){
        guard !email.isEmpty else {
            return
        }
        userRepository.recover(email: email){(success, error) in
            if let error = error {
                print(error)
            }
            
        }
    }
    
    func signUp(email: String, password: String){
        self.errorSignUp = false
        guard !email.isEmpty && !password.isEmpty else {
                return
            }
        userRepository.registerUser(email: email, password: password){(success, error) in
            if let error = error{
                switch error{
                case .unauthorized(reason: let reason):
                    self.errorType = reason
                case .inter(reason: let reason):
                    self.errorType = reason
                default:
                    print(error)
                }
                self.errorSignUp = true
                self.notificationErrorSignUp = true
            }else{
                if let success = success{
                    if success == true{
                        //UserDefaults.standard.set(true, forKey: "isLogged")
                        self.userCreated = true
                        self.errorSignUp = false
                    }
                }
            }
            
        }
    }
    
    
}
