//
//  MockPathologyRepository.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 12/01/23.
//

import Foundation
import SwiftKeychainWrapper
import CoreData
@testable import Healthub
class MockPathologyRepository: Healthub.PathologyRepositoryProcotol{
    
    private(set) var pathologies: [Healthub.Pathology] = []
    private(set) var testAddPathology : String = ""
    private(set) var testRemoveId : Int = 0
    
    init(){
        let entityPathology = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology = Healthub.Pathology(entity: entityPathology, insertInto: nil)
        pathology.id = 1
        pathology.name = "pathologyA"
        pathologies.append(pathology)
        
        let pathology2 = Healthub.Pathology(entity: entityPathology, insertInto: nil)
        pathology2.id = 2
        pathology2.name = "pathologyB"
        pathologies.append(pathology2)
        
    }
    
    func add(pathologyName: String, completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.testAddPathology = pathologyName
        
        completionHandler(true, nil)
    }
    
    func delete(pathologyId: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.testRemoveId = pathologyId
        completionHandler(true, nil)
    }
    
    func getAll(force_reload: Bool, completionHandler: @escaping ([Healthub.Pathology]?, Error?) -> Void) {
        
        completionHandler(pathologies, nil)
    }
    
    
    
}
