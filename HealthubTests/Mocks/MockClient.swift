//
//  MockClient.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import Foundation
@testable import Healthub

class MockClient: Healthub.ClientProtocol{

    private(set) var numberLogin = 0
    private(set) var numberLogout = 0
    private(set) var numberGetUser = 0
    private(set) var numberRecover = 0
    private(set) var numberRegister = 0
    private(set) var numberDeletePathology = 0
    private(set) var deletedPathologyId = 0
    private(set) var deleted = 0
    private(set) var testEmail: String!
    private(set) var testPassword: String!
    private(set) var updatePatient: Healthub.API.Types.Request.UpdatePatient!
    private(set) var numberAddPathology = 0
    private(set) var addPathology : Healthub.API.Types.Request.AddPathology!
    private(set) var numberGetPathologies = 0
    private(set) var pathologies:[Healthub.API.Types.Response.GetPathologies.PathologyElement] = []
    
    private (set) var patient = Healthub.API.Types.Response.GetPatient(email: "dispoto97@gmail.com", name: "Giovanni Dispoto", sex: 0, dateOfBirth: "1997-09-18", fiscalCode: "DSPGNN97P18L113H", height: 173, weight: 78, phone: "+393318669067", pathologies: [])
    
    func fetch<Request, Response>(_ endpoint:  Healthub.API.Types.Endpoint, method:  Healthub.API.Types.Method, body: Request?, then callback: ((Result<Response,  Healthub.API.Types.Error>) -> Void)?) where Request : Encodable, Response : Decodable {
        
        switch(endpoint){
            
        case .login(_, _):
            callback?(.success( Healthub.API.Types.Response.UserLogin(access_token: "1234") as! Response))
            numberLogin = numberLogin + 1
        case .logout(_):
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response ))
            self.numberLogout = self.numberLogout + 1
        case .getPathologies(_):
            if let p = addPathology {
                let buildPathology =  Healthub.API.Types.Response.GetPathologies.PathologyElement(id: 1, name: p.name)
                self.pathologies.append(buildPathology)
            }
            callback?(.success(Healthub.API.Types.Response.GetPathologies(pathologies: pathologies) as! Response ))
        case .deletePathology( _, let id):
            self.numberDeletePathology = self.numberDeletePathology + 1
            self.deletedPathologyId = id
            callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response ))
        case .addPathology(_):
                self.numberAddPathology = self.numberAddPathology + 1
            self.addPathology = body as!  Healthub.API.Types.Request.AddPathology

                
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response ))
        case .getPatient(_):
            self.numberGetUser = self.numberGetUser + 1
            callback?(.success(patient as! Response))
        case .updatePatient(_):
            self.updatePatient = body as!  Healthub.API.Types.Request.UpdatePatient
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
        
        case .createPatient:
            self.numberRegister = self.numberRegister + 1
            let patient = body as! Healthub.API.Types.Request.CreatePatient
            self.testEmail = patient.email
            self.testPassword = patient.password
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response ))
        
        case .resetPassword(email: let email):
            
            self.numberRecover = self.numberRecover + 1
            self.testEmail = email
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response ))
            
        default:
            print("else")
        }
    }
    
    func get<Response>(_ endpoint:  Healthub.API.Types.Endpoint, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Response : Decodable {
        switch(endpoint){
            
        case .login(_, _):
            callback?(.success(Healthub.API.Types.Response.UserLogin(access_token: "1234") as! Response))
            numberLogin = numberLogin + 1
        case .logout(_):
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response ))
            self.numberLogout = self.numberLogout + 1
        case .getPathologies(_):
            var pathologies:[ Healthub.API.Types.Response.GetPathologies.PathologyElement] = []
            pathologies.append(Healthub.API.Types.Response.GetPathologies.PathologyElement(id: 1, name: "pathology A"))
            pathologies.append(Healthub.API.Types.Response.GetPathologies.PathologyElement(id: 2, name: "pathology B"))
           
            callback?(.success( Healthub.API.Types.Response.GetPathologies(pathologies: pathologies) as! Response ))
            self.numberGetPathologies = self.numberGetPathologies + 1
        case .deletePathology( _,  _):
            print("deletePahologies")
        case .addPathology(_):
            print("addPathology")
        case .getPatient(_):
            self.numberGetUser = self.numberGetUser + 1
            callback?(.success( Healthub.API.Types.Response.GetPatient(email: "dispoto97@gmail.com", name: "Giovanni Dispoto", sex: 0, dateOfBirth: "1997-09-18", fiscalCode: "DSPGNN97P18L113H", height: 173, weight: 78, phone: "+393318669067", pathologies: []) as! Response))
        case .updatePatient(_):
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
        case .getReservations(token: let token):
            print("getReservations")
        case .addReservation(token: let token):
            print("addReservation")
        case .deleteReservation(token: let token, reservation_id: let reservation_id):
            print("deleteReservation")
        case .createPatient:
            self.numberRegister = self.numberRegister + 1
        case .resetPassword(email: let email):
            
            self.numberRecover = self.numberRecover + 1
            self.testEmail = email
            callback?(.success( Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response ))
       
        default:
            print("else")
        }
    }
}
