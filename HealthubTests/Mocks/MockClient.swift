//
//  MockClient.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import Foundation
@testable import Healthub

class MockClient: ClientProtocol{
    
    private(set) var numberLogin = 0
    private(set) var numberLogout = 0
    private(set) var numberGetUser = 0
    private(set) var numberDeletePathology = 0
    private(set) var updatePatient: API.Types.Request.UpdatePatient!
    private(set) var numberAddPathology = 0
    private(set) var addPathology : API.Types.Request.AddPathology!
    private(set) var numberGetPathologies = 0
    private(set) var pathologies:[API.Types.Response.GetPathologies.PathologyElement] = []
    
    private (set) var patient = API.Types.Response.GetPatient(email: "dispoto97@gmail.com", name: "Giovanni Dispoto", sex: 0, dateOfBirth: "1997-09-18", fiscalCode: "DSPGNN97P18L113H", height: 173, weight: 78, phone: "+393318669067", pathologies: [])
    
    func fetch<Request, Response>(_ endpoint: Healthub.API.Types.Endpoint, method: Healthub.API.Types.Method, body: Request?, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Request : Encodable, Response : Decodable {
        
        switch(endpoint){
            
        case .login(_, _):
            callback?(.success(API.Types.Response.UserLogin(access_token: "1234") as! Response))
            numberLogin = numberLogin + 1
        case .logout(_):
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response ))
            self.numberLogout = self.numberLogout + 1
        case .getPathologies(_):
            if let p = addPathology{
                let buildPathology = API.Types.Response.GetPathologies.PathologyElement(id: 1, name: p.name)
                self.pathologies.append(buildPathology)
            }
            callback?(.success(API.Types.Response.GetPathologies(pathologies: pathologies) as! Response ))
        case .deletePathology( _, let id):
            self.numberDeletePathology = self.numberDeletePathology + 1
            if pathologies.count > 0{
                
                if let element = pathologies.enumerated().first(where: {$0.element.id == id }){
                    pathologies.remove(at: element.offset)
                }else{
                    assertionFailure("Try to remove element that is not present")
                }
            }
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response ))
        case .addPathology(_):
                self.numberAddPathology = self.numberAddPathology + 1
                self.addPathology = body as! API.Types.Request.AddPathology
                
                self.pathologies.append(API.Types.Response.GetPathologies.PathologyElement(id: pathologies.count + 1, name: addPathology.name))
                
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response ))
        case .getPatient(_):
            self.numberGetUser = self.numberGetUser + 1
            callback?(.success(patient as! Response))
        case .updatePatient(_):
            self.updatePatient = body as! API.Types.Request.UpdatePatient
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response))
        }
    }
    
    func get<Response>(_ endpoint: Healthub.API.Types.Endpoint, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Response : Decodable {
        switch(endpoint){
            
        case .login(_, _):
            callback?(.success(API.Types.Response.UserLogin(access_token: "1234") as! Response))
            numberLogin = numberLogin + 1
        case .logout(_):
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response ))
            self.numberLogout = self.numberLogout + 1
        case .getPathologies(_):
            var pathologies:[API.Types.Response.GetPathologies.PathologyElement] = []
            
            if let p = addPathology{
                let buildPathology = API.Types.Response.GetPathologies.PathologyElement(id: 1, name: p.name)
                pathologies.append(buildPathology)
            }
            callback?(.success(API.Types.Response.GetPathologies(pathologies: pathologies) as! Response ))
            self.numberGetPathologies = self.numberGetPathologies + 1
        case .deletePathology( _,  _):
            print("deletePahologies")
        case .addPathology(_):
            print("addPathology")
        case .getPatient(_):
            self.numberGetUser = self.numberGetUser + 1
            callback?(.success(API.Types.Response.GetPatient(email: "dispoto97@gmail.com", name: "Giovanni Dispoto", sex: 0, dateOfBirth: "1997-09-18", fiscalCode: "DSPGNN97P18L113H", height: 173, weight: 78, phone: "+393318669067", pathologies: []) as! Response))
        case .updatePatient(_):
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response))
        }
    }
    
    
    
    
}
