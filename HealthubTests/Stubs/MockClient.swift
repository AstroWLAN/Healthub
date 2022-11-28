//
//  ClientStub.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import Foundation
@testable import Healthub

class MockClient: ClientProtocol{
    func fetch<Request, Response>(_ endpoint: Healthub.API.Types.Endpoint, method: Healthub.API.Types.Method, body: Request?, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Request : Encodable, Response : Decodable {
        
        switch(endpoint){
            
        case .login(let email, let password):
            callback?(.success(API.Types.Response.UserLogin(access_token: "1234") as! Response))
        case .logout(let token):
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response ))
        case .getPathologies( let token):
            print("getPathologies")
        case .deletePathology(let token, let id):
            print("deletePahologies")
        case .addPathology( let token):
            print("addPathology")
        case .getPatient(let token):
            callback?(.success(API.Types.Response.GetPatient(email: "dispoto97@gmail.com", name: "Giovanni Dispoto", sex: 0, dateOfBirth: "1997-09-18", fiscalCode: "DSPGNN97P18L113H", height: 173, weight: 78, phone: "+393318669067", pathologies: []) as! Response))
        case .updatePatient(let token):
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response))
        }
    }
    
    func get<Response>(_ endpoint: Healthub.API.Types.Endpoint, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Response : Decodable {
        print("reponse")
    }
    
    
    
    
}
