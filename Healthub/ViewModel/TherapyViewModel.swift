//
//  TherapyViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
import Combine

class TherapyViewModel: ObservableObject{
    private let therapyRepository: any TherapyRepositoryProtocol
    private(set) var connectivityProvider: any ConnectionProviderProtocol
    @Published private(set) var drugs: [Drug] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    @Published private(set) var therapies: [Therapy] = []{
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var hasError: Bool = false
    @Published var completedCreation: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    var objectWillChange = PassthroughSubject<Void, Never>()
    @Published var isLoadingTherapies = false {
        willSet {
            objectWillChange.send()
        }
    }

    
    init(therapyRepository: any TherapyRepositoryProtocol,  connectivityProvider: any ConnectionProviderProtocol) {
        self.therapyRepository = therapyRepository
        self.connectivityProvider = connectivityProvider
        connectivityProvider.connect()
        
    }
    
    func fetchDrugList(query: String){
        therapyRepository.getDrugList(query: query){ (drugs, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let drugs = drugs{
                self.drugs = drugs
            }
        }
    }
    
    func fetchTherapies(force_reload: Bool = false){
        self.isLoadingTherapies = true
        therapyRepository.getAll(force_reload: force_reload){(therapies, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                
                if let therapies = therapies{
                    self.therapies = therapies
                    self.connectivityProvider.connect()
                    self.connectivityProvider.sendWatchMessageTherapies(therapies)
                }
                
                self.isLoadingTherapies = false
                
            }
        /*}else{
            if let cachedVersion = cache.object(forKey: "therapies" as NSString) as? [Therapy] {
                // use the cached version
                self.therapies = cachedVersion
                self.isLoadingTherapies = false
            } else {
                // create it from scratch then store in the cache
                therapyRepository.getAll(){(therapies, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    
                    if let therapies = therapies{
                        self.therapies = therapies
                        self.cache.setObject(therapies as NSArray, forKey: "therapies")
                    }
                    
                    self.isLoadingTherapies = false
                    
                }
            }
        }*/
        
       
    }
    
    func createNewTherapy(drugs: [Drug], duration:String, name: String, comment: String){
        hasError = false
        completedCreation = false
        var drug_ids:[Int16] = []
        
        for d in drugs{
            drug_ids.append(d.id)
        }
        therapyRepository.createTherapy(drug_ids: drug_ids, duration: duration, name: name, comment: comment){(success, error) in
            if let _ = error{
                self.hasError = true
            }else{
                self.fetchTherapies(force_reload: true)
                self.completedCreation = true
            }
            
        }
    }
    
    func deleteTherapy(therapy_id : Int){
        let interactions = self.therapies.first(where: {$0.id == therapy_id})?.interactions
        
        self.therapies = self.therapies.filter{$0.id != therapy_id}
        therapyRepository.removeTherapy(therapy_id: therapy_id){(success, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
            if success == true {
                if interactions?.isEmpty == false {
                        self.fetchTherapies(force_reload: true)
                    }
                }
            }
       
    }
    
}
