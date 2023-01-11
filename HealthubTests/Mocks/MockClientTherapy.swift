//
//  MockClientTherapy.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import Foundation
@testable import Healthub

class MockClientTherapy: Healthub.ClientProtocol{
    
    private(set) var numberGetAll = 0
    private(set) var numberRemove = 0
    private(set) var therapyIdRemoved = 0
    private(set) var createTherapyName: String!
    private(set) var createTherapyDrugsId:[Int16] = []
    private(set) var createTherapyComment:String!
    private(set) var testQuery: String!
    
    
    func fetch<Request, Response>(_ endpoint: Healthub.API.Types.Endpoint, method: Healthub.API.Types.Method, body: Request?, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Request : Encodable, Response : Decodable {
        switch(endpoint){
        case .getTherapies(token: let token):
            self.numberGetAll = self.numberGetAll + 1
            var therapies: [Healthub.API.Types.Response.GetTherapies.TherapyElement] = []
            var drugs: [API.Types.Response.GetTherapies.DrugElement] = []
            drugs.append(API.Types.Response.GetTherapies.DrugElement(id: 1, group_description: "test", ma_holder: "test", equivalence_group_code: "test", denomination_and_packaging: "test", active_principle: "paracetamol", ma_code: "test"))
            therapies.append(Healthub.API.Types.Response.GetTherapies.TherapyElement(therapy_id: 1, drugs: drugs, duration: "10", comment: "no comment", name: "Therapy 1", interactions: []))
            let response = Healthub.API.Types.Response.GetTherapies(therapies: therapies)
            callback?(.success(response as! Response))
        
        case .createTherapy(token: let token):
            
            let therapy = body as! Healthub.API.Types.Request.CreateTherapy
            self.createTherapyName = therapy.name
            self.createTherapyComment = therapy.comment
            self.createTherapyDrugsId = therapy.drug_ids
            
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
            
            
        case .deleteTherapy(token: let token, therapy_id: let therapy_id):
            self.numberRemove = self.numberRemove + 1
            self.therapyIdRemoved = therapy_id
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
        default:
            print("Default")
        }
    }
    
    func get<Response>(_ endpoint: Healthub.API.Types.Endpoint, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Response : Decodable {
        switch(endpoint){
        case .getTherapies(token: let token):
            self.numberGetAll = self.numberGetAll + 1
            var therapies: [Healthub.API.Types.Response.GetTherapies.TherapyElement] = []
            var drugs: [API.Types.Response.GetTherapies.DrugElement] = []
            drugs.append(API.Types.Response.GetTherapies.DrugElement(id: 1, group_description: "test", ma_holder: "test", equivalence_group_code: "test", denomination_and_packaging: "test", active_principle: "paracetamol", ma_code: "test"))
            therapies.append(Healthub.API.Types.Response.GetTherapies.TherapyElement(therapy_id: 1, drugs: drugs, duration: "10", comment: "no comment", name: "Therapy 1", interactions: []))
            let response = Healthub.API.Types.Response.GetTherapies(therapies: therapies)
            callback?(.success(response as! Response))
            
        case .deleteTherapy(token: let token, therapy_id: let therapy_id):
            self.numberRemove = self.numberRemove + 1
            self.therapyIdRemoved = therapy_id
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
        case .getDrugList(query: let query):
            self.testQuery = query
            var drugs:[Healthub.API.Types.Response.Search.DrugElement] = []
            
            drugs.append(Healthub.API.Types.Response.Search.DrugElement(id: 1, group_description: "test", ma_holder: "test", equivalence_group_code: "test", denomination_and_packaging: "test", active_principle: "paracetamol", ma_code: "test"))
            let response: Healthub.API.Types.Response.Search = Healthub.API.Types.Response.Search(medications: drugs)
            
            callback?(.success(response as! Response))
        
        default:
            print("Default")
        }
    }
    
    
    
}
