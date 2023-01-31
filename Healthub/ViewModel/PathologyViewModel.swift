//
//  PathologiesViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 18/11/22.
//

import Foundation
import SwiftKeychainWrapper

class PathologyViewModel : ObservableObject {
    
    @Published
    private(set) var pathologies: [Pathology] = []
    private var hasError: Bool = false
    @Published var isLoadingPathologies = false
    private let pathologyRepository: any PathologyRepositoryProcotol
    private(set) var connectivityProvider: any ConnectionProviderProtocol
    
    var onError: ((String) -> Void)?
    
    init(pathologyRepository: any PathologyRepositoryProcotol, connectivityProvider: any ConnectionProviderProtocol){
        self.pathologyRepository = pathologyRepository
        self.connectivityProvider = connectivityProvider
        connectivityProvider.connect()
    }
    
    
    func fetchPathologies(force_reload: Bool = false){
        //Retrieve token in order to prepare the request
        self.isLoadingPathologies = true
        pathologyRepository.getAll(force_reload: force_reload){ (pathologies, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let pathologies = pathologies{
                self.pathologies = pathologies
                self.isLoadingPathologies = false
                self.connectivityProvider.connect()
                self.connectivityProvider.sendWatchMessagePathologies(pathologies)
            }
            
        }
        
    }
    
    
    func addPathology(pathology: String){
        
        pathologyRepository.add(pathologyName: pathology){ (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let success = success {
                if(success == false){
                    print("Problem in adding the pathology")
                }
                self.fetchPathologies(force_reload: true)
            }
            
            
        }
        
    }
    
    func removePathology(at offset: Int){
        let pathology = pathologies[offset]
        pathologies.remove(at: offset)
        pathologyRepository.delete(pathologyId: Int(pathology.id)){ (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let success = success {
                if(success == false){
                    print("Problem in deleting the pathology")
                }
                
            }
            
        }
        
    }
}
