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
    @Published var isLoadingPathologies = false
    private let pathologiesRepository: any PathologyRepositoryProcotol
    
    var onError: ((String) -> Void)?
    
    init(pathologiesRepository: any PathologyRepositoryProcotol){
        self.pathologiesRepository = pathologiesRepository
    }
    
    
    func fetchPathologies(){
        //Retrieve token in order to prepare the request
        self.isLoadingPathologies = true
        pathologiesRepository.getAll{ (pathologies, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let pathologies = pathologies{
                self.pathologies = pathologies
                self.isLoadingPathologies = false
            }
            
        }
        
    }
    
    
    func addPathology(pathology: String){
        
        pathologiesRepository.add(pathologyName: pathology){ (success, error) in
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
    
    func removePathology(at offset: Int){
        let pathology = pathologies[offset]
        
        pathologiesRepository.delete(pathologyId: pathology.id){ (success, error) in
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
