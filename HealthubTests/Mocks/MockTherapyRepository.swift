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
struct MockTherapyRepository: Healthub.TherapyRepositoryProtocol{
    
    private var therapies: [Healthub.Therapy] = []
    
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
        
    }
    
    func getAll(force_reload: Bool, completionHandler: @escaping ([Healthub.Therapy]?, Error?) -> Void) {
        completionHandler(self.therapies, nil)
    }
    
    func createTherapy(drug_ids: [Int16], duration: String, name: String, comment: String, completionHandler: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func removeTherapy(therapy_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    
    
}
