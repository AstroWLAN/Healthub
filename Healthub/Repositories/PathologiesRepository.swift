//
//  PathologiesRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import SwiftKeychainWrapper

struct PathologiesRepository : PathologyRepositoryProcotol{
    
    
    typealias T = Pathology
    private var client: any ClientProtocol
    
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
    
    func getAll(completionHandler: @escaping ([Pathology]?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        
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
    
    
    
    private func processPathologies(_ results: API.Types.Response.GetPathologies) -> [Pathology]{
        var local = [Pathology]()
        
        for result in results.pathologies{
            let pathology = Pathology(id: result.id, name: result.name)
            local.append(pathology)
        }
        
        return local
        
    }
}
