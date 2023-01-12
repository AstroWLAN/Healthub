//
//  TherapyViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class TherapyViewModelTests: XCTestCase {
    
    private var therapyViewModel: Healthub.TherapyViewModel!
    private var therapyRepository: MockTherapyRepository!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        therapyRepository = MockTherapyRepository()
        therapyViewModel = Healthub.TherapyViewModel(therapyRepository: therapyRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
    }


    func testFetchDrugList(){
        let query = "query"
        therapyViewModel.fetchDrugList(query: query)
        XCTAssertEqual(therapyRepository.testQuery, query)
        XCTAssertEqual(therapyViewModel.drugs.count, 2)
        XCTAssertEqual(therapyViewModel.drugs[0].id, 1)
        XCTAssertEqual(therapyViewModel.drugs[0].active_principle, "A")
        XCTAssertEqual(therapyViewModel.drugs[1].id, 2)
        XCTAssertEqual(therapyViewModel.drugs[1].active_principle, "B")
    }
    
    func testFetchTherapies(){
        therapyViewModel.fetchTherapies()
        
        XCTAssertEqual(therapyViewModel.therapies.count, 1)
        XCTAssertEqual(therapyViewModel.therapies[0].name, "therapy 1")
        XCTAssertEqual(therapyViewModel.therapies[0].drugs.count, 1)
        
        
    }
    
    func testCreateNewTherapy(){
        let entity = NSEntityDescription.entity(forEntityName: "Drug", in: Healthub.CoreDataHelper.context)!
        var drugs: [Drug] = []
        let duration = "10"
        let name = "therpy 1"
        let comment = "comment 1"
        let drug = Drug(entity: entity, insertInto: nil)
        drug.id = 1
        drug.ma_code = "A"
        drug.active_principle = "A"
        drug.denomination_and_packaging = "A"
        drug.equivalence_group_code = "A"
        drug.group_description = "A"
        drug.ma_holder = "A"
        
        drugs.append(drug)
        
        therapyViewModel.createNewTherapy(drugs: drugs, duration: duration, name: name, comment: comment)
        
        XCTAssertEqual(therapyRepository.therapyComment, comment)
        XCTAssertEqual(therapyRepository.therapyName, name)
        XCTAssertEqual(therapyRepository.therapyDuration, duration)
        XCTAssertEqual(therapyRepository.therapyDrugsIds.count, 1)
        XCTAssertNotEqual(therapyRepository.therapyDrugsIds.count, 2)
        XCTAssertEqual(therapyRepository.therapyDrugsIds[0], drug.id)
        
        
        
    }
    
    func testDeleteTherapy(){
        let therapy_id = 1
        therapyViewModel.deleteTherapy(therapy_id: therapy_id)
        XCTAssertEqual(therapyRepository.therapyRemoveId, therapy_id)
        
        
        
    }

}
