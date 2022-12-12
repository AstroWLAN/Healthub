//
//  TherapyRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
import SwiftKeychainWrapper

class TherapyRepository: TherapyRepositoryProtocol{
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
    
    func getAll(completionHandler: @escaping (Bool?, Error?) -> Void) {
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        client
            .get(.getTherapies(token: token!)){ (result: Result<API.Types.Response.GetTherapies, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        print(success)
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
    
    
    private var client: any ClientProtocol
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    
}
