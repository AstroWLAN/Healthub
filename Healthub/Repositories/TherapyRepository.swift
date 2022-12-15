//
//  TherapyRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
import SwiftKeychainWrapper

class TherapyRepository: TherapyRepositoryProtocol{
    
    private var client: any ClientProtocol
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    func getDrugList(query: String, completionHandler: @escaping ([Drug]?, Error?) -> Void) {
        client
            .get(.getDrugList(query: query)){(result: Result<API.Types.Response.Search, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(self.processDrugSearch(success), nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
    }
    
    func getAll(completionHandler: @escaping ([Therapy]?, Error?) -> Void) {
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        client
            .get(.getTherapies(token: token!)){ (result: Result<API.Types.Response.GetTherapies, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(self.processTherapies(success),nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
                
            }
    }
    
    func createTherapy(drug_ids: [Int], duration: String, name: String, comment: String, completionHandler: @escaping (Bool?, Error?) -> Void){
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        let body = API.Types.Request.CreateTherapy(drug_ids: drug_ids, duration: duration, name: name, comment: comment)
        client
            .fetch(.createTherapy(token: token!), method: .post, body: body){ (result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK",nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
                
            }
    }
    
    private func processDrugSearch(_ results: API.Types.Response.Search)->[Drug]{
        var local = [Drug]()
        
        for result in results.medications{
            let drug = Drug(id: result.id, group_description: result.group_description, ma_holder: result.ma_holder, equivalence_group_code: result.equivalence_group_code, denomination_and_packaging: result.denomination_and_packaging, active_principle: result.active_principle, ma_code: result.ma_code)
            local.append(drug)
        }
        
        return local
    }
    
    private func processTherapies(_ results: API.Types.Response.GetTherapies)->[Therapy]{
        var local = [Therapy]()
       
        
        for result in results.therapies{
            var drugs: [Drug] = []
            var doctor: Doctor? = nil
            
            
            for d in result.drugs{
                    drugs.append(Drug(id: d.id, group_description: d.group_description, ma_holder: d.ma_holder, equivalence_group_code: d.equivalence_group_code, denomination_and_packaging: d.denomination_and_packaging, active_principle: d.active_principle, ma_code: d.ma_code))
                    
                }
                
            
            
            if result.doctor != nil{
                doctor = Doctor(id: result.doctor!.id, name: result.doctor!.name, address: result.doctor!.address)
            }
            
            
            let therapy = Therapy(id: result.therapy_id, name: result.name, doctor: doctor, duration: result.duration, drugs: drugs, notes: result.comment, interactions: result.interactions)
            
            local.append(therapy)
        }
        
        return local
    }
    
    
    
    
}
