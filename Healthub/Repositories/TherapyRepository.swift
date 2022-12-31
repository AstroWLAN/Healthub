//
//  TherapyRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/12/22.
//

import Foundation
import SwiftKeychainWrapper
import CoreData

class TherapyRepository: TherapyRepositoryProtocol{
    
    private var client: any ClientProtocol
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
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
    
    func getAll(force_reload: Bool = false, completionHandler: @escaping ([Therapy]?, Error?) -> Void) {
        
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        if force_reload == false {
            let result: Result<[Therapy], Error> = dbHelper.fetch(Therapy.self, predicate: nil)
            
            switch result {
            case .success(let therapies):
                if therapies.isEmpty == false{
                    completionHandler(therapies, nil)
                }else{
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
            case .failure(let error):
                print(error)
            }
        }else{
            dbHelper.deleteAllEntries(entity: "Therapy")
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
        
        
    }
    
    func createTherapy(drug_ids: [Int16], duration: String, name: String, comment: String, completionHandler: @escaping (Bool?, Error?) -> Void){
        let token = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
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
            let drug = Drug(entity: Drug().entity, insertInto: dbHelper.context)//(id: result.id, group_description: result.group_description, ma_holder: result.ma_holder, equivalence_group_code: result.equivalence_group_code, denomination_and_packaging: result.denomination_and_packaging, active_principle: result.active_principle, ma_code: result.ma_code)
            drug.id = Int16(result.id)
            drug.group_description = result.group_description
            drug.ma_holder = result.ma_holder
            drug.ma_code = result.ma_code
            drug.equivalence_group_code = result.equivalence_group_code
            drug.denomination_and_packaging = result.denomination_and_packaging
            drug.active_principle = result.active_principle
            local.append(drug)
        }
        
        return local
    }
    
    private func processTherapies(_ results: API.Types.Response.GetTherapies)->[Therapy]{
        var local = [Therapy]()
       
        
        for result in results.therapies{
            var drugs: Set<Drug> = Set.init()
            var doctor: Doctor? = nil
            
            
            for d in result.drugs{
                
                //let entity = NSEntityDescription.entity(forEntityName: "Drug", in: dbHelper.context)!
                
                let drug = Drug(entity: Drug().entity, insertInto: dbHelper.context)
                drug.id = Int16(d.id)
                drug.group_description = d.group_description
                drug.ma_holder = d.ma_holder
                drug.ma_code = d.ma_code
                drug.denomination_and_packaging = d.denomination_and_packaging
                drug.active_principle = d.active_principle
                drug.equivalence_group_code = d.equivalence_group_code
                
                dbHelper.create(drug)
                drugs.insert(drug)
                    
                }
                
            
            
            if result.doctor != nil{
                let entity = Doctor().entity
                doctor = Doctor(entity: entity, insertInto: dbHelper.context ) //(id: result.doctor!.id, name: result.doctor!.name, address: result.doctor!.address)
                doctor!.id = Int16(result.doctor!.id)
                doctor!.name = result.doctor!.name
                doctor!.address = result.doctor!.address
                
                dbHelper.create(doctor!)
            }
            
    
            let therapy = Therapy(entity: Therapy().entity, insertInto: dbHelper.context)//(id: result.therapy_id, name: result.name, doctor: doctor, duration: result.duration, drugs: drugs, notes: result.comment, interactions: result.interactions)
            therapy.id = Int16(result.therapy_id)
            therapy.name = result.name
            therapy.doctor = doctor
            therapy.duration = result.duration
            therapy.drugs = drugs
            therapy.notes = result.comment
            therapy.interactions = result.interactions
            dbHelper.create(therapy)
            local.append(therapy)
        }
        
        return local
    }
    
    
    
    
}
