//
//  LoginViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/11/22.
//

import Foundation
import SwiftKeychainWrapper

class LoginViewModel: ObservableObject {
    
    private var hasError: Bool = false
    private var isSigningIn: Bool = false
    var isSigned : Bool {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "access_token")
        
        if let t = retrievedString{
            return true
        }
        
        return false
    }
    
    
    func doLogin(email: String, password: String){
        guard !email.isEmpty && !password.isEmpty else {
                return
            }
        
        var request = URLRequest(url: URL(string: "https://localhost/auth?email=\(email)&password=\(password)")!)
        request.httpMethod = "POST"

        isSigningIn = true

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    self?.hasError = true
                    print("Authentication failed")
                } else if let data = data {
                    do {
                            let signInResponse = try JSONDecoder().decode(UserLogin.self, from: data)
                            let saveSuccessful: Bool = KeychainWrapper.standard.set(signInResponse.access_token, forKey: "access_token")
                            
                        if saveSuccessful == false {
                            print("Unable to Save Token")
                        }

                            // TODO: Cache Access Token in Keychain
                        } catch {
                            print("Unable to Decode Response \(error)")
                            }
                }

                self?.isSigningIn = false
            }
        }.resume()
        
    }
    
    
    
    
    
}
