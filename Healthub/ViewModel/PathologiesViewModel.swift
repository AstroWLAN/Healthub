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
    private let pathologiesRepository = PathologiesRepository()
    
    var onError: ((String) -> Void)?
    
    
    /*
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
     */
    func fetchPathologies(){
        //Retrieve token in order to prepare the request
        
        pathologiesRepository.getAll{ (pathologies, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let pathologies = pathologies{
                self.pathologies = pathologies
            }
            
        }
        
    }
    
    
    func addPathology(pathology: String){
        
        pathologiesRepository.add(Pathology(id: 0, name: pathology)){ (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let success = success {
                if(success == false){
                    print("Problem in adding the pathology")
                }
                self.fetchPathologies()
            }
            
            
        }
        
    }
    
    func removePathology(at offsets: IndexSet){
        let pathology = pathologies[offsets.first!]
        
        pathologiesRepository.delete(pathology){ (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let success = success {
                if(success == false){
                    print("Problem in deleting the pathology")
                }
                
                self.fetchPathologies()
            }
            
        }
        
    }
}
