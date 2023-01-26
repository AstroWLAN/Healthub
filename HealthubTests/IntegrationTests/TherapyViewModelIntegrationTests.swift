//
//  TherapyViewModelIntegrationTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class TherapyViewModelIntegrationTests: XCTestCase {
    
    private var therapyViewModel: Healthub.TherapyViewModel!
    private var therapyRepository: Healthub.TherapyRepository!
    private var clientAPI: MockClientTherapy!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
        clientAPI = MockClientTherapy()
        therapyRepository = Healthub.TherapyRepository(client: clientAPI, dbHelper: MockDBHelper())
        therapyViewModel = Healthub.TherapyViewModel(therapyRepository: therapyRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }


    func testFetchDrugList(){
        let query = "query"
        let expectation = XCTestExpectation(description: "Object's property should change")
        therapyViewModel.fetchDrugList(query: query)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.testQuery, query)
            XCTAssertEqual(self.therapyViewModel.drugs.count, 1)
            XCTAssertEqual(self.therapyViewModel.drugs[0].id, 1)
            XCTAssertEqual(self.therapyViewModel.drugs[0].active_principle, "paracetamol")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testFetchTherapies(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        therapyViewModel.fetchTherapies()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.therapyViewModel.therapies.count, 1)
            XCTAssertEqual(self.therapyViewModel.therapies[0].name, "Therapy 1")
            XCTAssertEqual(self.therapyViewModel.therapies[0].drugs.count, 1)
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testCreateNewTherapy(){
        let expectation = XCTestExpectation(description: "Object's property should change")
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.createTherapyComment, comment)
            XCTAssertEqual(self.clientAPI.createTherapyName, name)
            XCTAssertEqual(self.clientAPI.createTherapyDrugsId.count, 1)
            expectation.fulfill()
            }
        wait(for: [expectation], timeout: 4.0)
        
        
        
        
    }
    
    func testDeleteTherapy(){
        
        let therapy_id = 1
        let expectation2 = XCTestExpectation(description: "Object's property should change")
        therapyViewModel.deleteTherapy(therapy_id: therapy_id)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.therapyIdRemoved, therapy_id)
            
            expectation2.fulfill()
            }
       
        wait(for: [expectation2], timeout: 1.0)
        
        
        
        
    }

}
