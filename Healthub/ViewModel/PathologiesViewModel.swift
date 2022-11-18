//
//  PathologiesViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 18/11/22.
//

import Foundation
import SwiftKeychainWrapper

class PathologiesViewModel : ObservableObject {
    
    @Published
    private(set) var pathologies: [Pathology] = []
    private var hasError: Bool = false
    
    
    func fetchPatologies(){
        //Retrieve token in order to prepare the request
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        var request = URLRequest(url: URL(string: "https://localhost/patients/me/pathologies?token=\(token!)")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    self?.hasError = true
                    print("Authentication failed")
                } else if let data = data {
                    do {
                       let pathologies = try JSONDecoder().decode([Pathology].self, from: data)
                        self?.pathologies = pathologies
                        // let saveSuccessful: Bool = KeychainWrapper.standard.set(signInResponse.access_token, forKey: "access_token")
                        
                    }catch {
                        print("Unable to Decode Response \(error)")
                    }
                    
                }
            }
            
        }.resume()
        
    }
    func addPathology(pathology: String){
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        var request = URLRequest(url: URL(string: "https://localhost/patients/me/pathologies?token=\(token!)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json: [String: String] = ["name": pathology]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody=jsonData
        
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    self?.hasError = true
                    print("Authentication failed")
                } else if let data = data {
                    do {
                        print(data)
                        // let saveSuccessful: Bool = KeychainWrapper.standard.set(signInResponse.access_token, forKey: "access_token")
                        
                    }catch {
                        print("Unable to Decode Response \(error)")
                    }
                    
                }
            }
            
        }.resume()
        
    }
    
    func removePathology(at offsets: IndexSet){
        let pathology = pathologies[offsets.first!]
        
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        var request = URLRequest(url: URL(string: "https://localhost/patients/me/pathologies/\(String(pathology.id))?token=\(token!)")!)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    self?.hasError = true
                    print("Authentication failed")
                } else if let data = data {
                    do {
                        print(data)
                        // let saveSuccessful: Bool = KeychainWrapper.standard.set(signInResponse.access_token, forKey: "access_token")
                        
                    }catch {
                        print("Unable to Decode Response \(error)")
                    }
                    
                }
            }
            
        }.resume()
        
    }
}
