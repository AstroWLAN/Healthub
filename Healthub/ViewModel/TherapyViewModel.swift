//
//  TherapyViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation

class TherapyViewModel: ObservableObject{
    private let therapyRepository: any TherapyRepositoryProtocol
    @Published private(set) var drugs: [Drug] = []
    @Published private(set) var therapies: [Therapy] = []
    
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
    
    func fetchTherapies(){
        therapyRepository.getAll(){(therapies, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let therapies = therapies{
                self.therapies = therapies
            }
            
        }
    }
    
}
