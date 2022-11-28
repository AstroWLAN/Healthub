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
    private let pathologiesRepository: any PathologyRepositoryProcotol
    
    var onError: ((String) -> Void)?
    
    init(pathologiesRepository: any PathologyRepositoryProcotol){
        self.pathologiesRepository = pathologiesRepository
    }
    
    
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
