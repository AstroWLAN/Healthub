//
//  PathologiesRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import SwiftKeychainWrapper

struct PathologyRepository : PathologyRepositoryProcotol{
    
    
    typealias T = Pathology
    private var client: any ClientProtocol
    private var dbHelper = CoreDataHelper.shared
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    
    func add(pathologyName:String, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
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
            fatalError("Token not present")
        }
        
        let body = API.Types.Request.Empty() //API.Types.Request.PathologyDelete(id: item.id)
        
       client
            .fetch(.deletePathology(token: token!, id: pathologyId), method: .delete, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
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
    
    func getAll(force_reload: Bool = false, completionHandler: @escaping ([Pathology]?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        
        if force_reload == false {
            let result: Result<[Pathology], Error> = dbHelper.fetch(Pathology.self, predicate: nil)
            
            switch result {
            case .success(let pathologies):
                if pathologies.isEmpty == false{
                    completionHandler(pathologies, nil)
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
            
            let pathology = Pathology(entity: Pathology().entity, insertInto: dbHelper.context)//(id: result.id, name: result.name)
            pathology.id = Int16(result.id)
            pathology.name = result.name
            dbHelper.create(pathology)
            local.append(pathology)
        }
        
        return local
        
    }
}
