//
//  TherapyViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

class TherapyViewModel: ObservableObject{
    private let therapyRepository: any TherapyRepositoryProtocol
    private let cache = NSCache<NSString, NSArray>()
    @Published private(set) var drugs: [Drug] = []
    @Published private(set) var therapies: [Therapy] = []
    
    @Published var hasError: Bool = false
    @Published var completedCreation: Bool = false
    
    init(therapyRepository: any TherapyRepositoryProtocol) {
        self.therapyRepository = therapyRepository
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
        
        if let cachedVersion = cache.object(forKey: "therapies" as NSString) as? [Therapy] {
            // use the cached version
            self.therapies = cachedVersion
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
                
            }
        }
        
      
    }
    
    func createNewTherapy(drugs: [Drug], duration:String, name: String, comment: String){
        hasError = false
        completedCreation = false
        var drug_ids:[Int] = []
        
        for d in drugs{
            drug_ids.append(d.id)
        }
        therapyRepository.createTherapy(drug_ids: drug_ids, duration: duration, name: name, comment: comment){(success, error) in
            if let _ = error{
                self.hasError = true
            }else{
                self.completedCreation = true
            }
            
        }
    }
    
}
