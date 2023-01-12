//
//  PathologiesRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import SwiftKeychainWrapper
import CoreData

struct PathologyRepository : PathologyRepositoryProcotol{
    
    
    private var client: any ClientProtocol
    private var dbHelper: any DBHelperProtocol
    
    init(client: any ClientProtocol, dbHelper: any DBHelperProtocol) {
        self.client = client
        self.dbHelper = dbHelper
    }
    
    
    func add(pathologyName:String, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        let body = API.Types.Request.AddPathology(name: pathologyName)
        
       client
            .fetch(.addPathology(token: token!), method: .post, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK", nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
        
        
    }
    
    func delete(pathologyId:Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        let body = API.Types.Request.Empty() //API.Types.Request.PathologyDelete(id: item.id)
        
       client
            .fetch(.deletePathology(token: token!, id: pathologyId), method: .delete, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK", nil)
                        let predicate = NSPredicate(
                            format: "id = %@",
                            NSNumber.init(value: pathologyId) as CVarArg)
                        
                        let result = dbHelper.fetchFirst(Pathology.self, predicate: predicate)
                        
                    switch result{
                        case .success(let reservation):
                        if reservation != nil {
                            dbHelper.delete(reservation!)
                        }
                        case .failure(_):
                            print("failure")
                        }
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
    }
    
    func getAll(force_reload: Bool = false, completionHandler: @escaping ([Pathology]?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            return
        }
        
        if force_reload == false {
            let result = dbHelper.fetch(Pathology.self, predicate: nil, limit: nil)
            
            switch result {
            case .success(let pathologies):
                if pathologies.isEmpty == false{
                    completionHandler(pathologies as! [Pathology], nil)
                }else{
                    client
                        .get(.getPathologies(token: token!)){ (result: Result<API.Types.Response.GetPathologies, API.Types.Error>) in
                            DispatchQueue.main.async {
                                switch result{
                                case .success(let success):
                                    completionHandler(self.processPathologies(success), nil)
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
            dbHelper.deleteAllEntries(entity: "Pathology")
            client
                .get(.getPathologies(token: token!)){ (result: Result<API.Types.Response.GetPathologies, API.Types.Error>) in
                    DispatchQueue.main.async {
                        switch result{
                        case .success(let success):
                            completionHandler(self.processPathologies(success), nil)
                        case .failure(let failure):
                            completionHandler(nil,failure)
                        }
                    }
            }
        }
        
        
    }
    
    
    
    private func processPathologies(_ results: API.Types.Response.GetPathologies) -> [Pathology]{
        var local = [Pathology]()
        
        for result in results.pathologies{
            let entity = NSEntityDescription.entity(forEntityName: "Pathology", in: dbHelper.getContext())!
            let pathology = Pathology(entity: entity, insertInto: dbHelper.getContext())//(id: result.id, name: result.name)
            pathology.id = Int16(result.id)
            pathology.name = result.name
            dbHelper.create(pathology)
            local.append(pathology)
        }
        
        return local
        
    }
}
