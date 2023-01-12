//
//  MockTherapyRepository.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import Foundation
import SwiftKeychainWrapper
import CoreData
@testable import Healthub
class MockTherapyRepository: Healthub.TherapyRepositoryProtocol{
    
    
    private(set) var therapies: [Healthub.Therapy] = []
    private(set) var therapyName : String = ""
    private(set) var therapyDuration : String = ""
    private(set) var therapyComment: String = ""
    private(set) var therapyDrugsIds : [Int16] = []
    private(set) var therapyRemoveId: Int = 0
    private(set) var testQuery: String = ""
    
    
    init(){
        let entityDrug = NSEntityDescription.entity(forEntityName: "Drug", in: Healthub.CoreDataHelper.context)!
        let drug = Healthub.Drug(entity: entityDrug, insertInto: nil)
        drug.id = 1
        drug.ma_code = "A"
        drug.active_principle = "A"
        drug.denomination_and_packaging = "A"
        drug.equivalence_group_code = "A"
        drug.group_description = "A"
        drug.ma_holder = "A"
        let entityDoctor = NSEntityDescription.entity(forEntityName: "Doctor", in: Healthub.CoreDataHelper.context)!
        let doctor = Healthub.Doctor(entity: entityDoctor, insertInto: nil)
        doctor.id = 1
        doctor.name = "Doctor 1"
        doctor.address = "address 1"
        doctor.email = "email@email.it"
        doctor.phone = "123"
        
        let entityTherapy = NSEntityDescription.entity(forEntityName: "Therapy", in: Healthub.CoreDataHelper.context)!
        let therapy = Healthub.Therapy(entity: entityTherapy, insertInto: nil)
        therapy.id = 1
        therapy.name = "therapy 1"
        therapy.doctor = doctor
        therapy.duration = "10 days"
        therapy.drugs = Set([drug])
        therapy.notes = ""
        therapy.interactions = []
        
        therapies.append(therapy)
    }
    
    func getDrugList(query: String, completionHandler: @escaping ([Healthub.Drug]?, Error?) -> Void) {
        var drugs: [Healthub.Drug] = []
        let entityDrug = NSEntityDescription.entity(forEntityName: "Drug", in: Healthub.CoreDataHelper.context)!
        let drug = Healthub.Drug(entity: entityDrug, insertInto: nil)
        drug.id = 1
        drug.ma_code = "A"
        drug.active_principle = "A"
        drug.denomination_and_packaging = "A"
        drug.equivalence_group_code = "A"
        drug.group_description = "A"
        drug.ma_holder = "A"
        
        drugs.append(drug)
        
        let entityDrug2 = NSEntityDescription.entity(forEntityName: "Drug", in: Healthub.CoreDataHelper.context)!
        let drug2 = Healthub.Drug(entity: entityDrug2, insertInto: nil)
        drug2.id = 2
        drug2.ma_code = "B"
        drug2.active_principle = "B"
        drug2.denomination_and_packaging = "B"
        drug2.equivalence_group_code = "B"
        drug2.group_description = "B"
        drug2.ma_holder = "B"
        
        drugs.append(drug2)
        
        self.testQuery = query
        
        completionHandler(drugs, nil)
    }
    
    func getAll(force_reload: Bool, completionHandler: @escaping ([Healthub.Therapy]?, Error?) -> Void) {
        completionHandler(self.therapies, nil)
    }
    
    func createTherapy(drug_ids: [Int16], duration: String, name: String, comment: String, completionHandler: @escaping (Bool?, Error?) -> Void) {
        
        self.therapyName = name
        self.therapyDuration = duration
        self.therapyDrugsIds = drug_ids
        self.therapyComment = comment
        completionHandler(true, nil)
    }
    
    func removeTherapy(therapy_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        
        self.therapyRemoveId = therapy_id
        completionHandler(true, nil)
    }
    
    
    
}
