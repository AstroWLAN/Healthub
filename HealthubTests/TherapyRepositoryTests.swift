//
//  TherapyRepositoryTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
@testable import Healthub
import SwiftKeychainWrapper

final class TherapyRepositoryTests: XCTestCase {
    
    private var therapyRepository: Healthub.TherapyRepository!
    private var mockClient: MockClientTherapy!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClient = MockClientTherapy()
        therapyRepository = Healthub.TherapyRepository(client: mockClient, dbHelper: MockDBHelper())
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }

    
    func testGetAll(){
        let exp = expectation(description: "test getAll")
        therapyRepository.getAll(force_reload: true) { therapies, error in
            XCTAssertNil(error)
            XCTAssertNotNil(therapies)
            XCTAssertEqual(therapies!.count, 1)
            XCTAssertEqual(therapies![0].drugs.count,1)
            XCTAssertEqual(Array(therapies![0].drugs)[0].active_principle, "paracetamol")
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetAll,1)
            }
        }
    }
    
    func testCreateTherapy(){
        let exp = expectation(description: "creation of a therapy")
        let name = "therapy test"
        let duration = "10"
        let drugs_ids: [Int16] = [1]
        let comment = "no comment"
        therapyRepository.createTherapy(drug_ids: drugs_ids, duration: duration, name: name, comment: comment) { success, error in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.createTherapyName, name)
                XCTAssertEqual(self.mockClient.createTherapyComment, comment)
                XCTAssertEqual(self.mockClient.createTherapyDrugsId, drugs_ids)
                
            }
        }
    }
    
    func testRemoveTherapy(){
        let exp = expectation(description: "test remove therapy")
        let therapy_id = 1
        therapyRepository.removeTherapy(therapy_id: therapy_id) { success, error in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
            XCTAssertTrue(success!)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberRemove, 1)
                XCTAssertEqual(self.mockClient.therapyIdRemoved, therapy_id)
                
            }
        }
        
    }
    
    func testGetDrugList(){
        let query = "para"
        let exp = expectation(description: "test getDrugList")
        therapyRepository.getDrugList(query: query) { drugs, error in
            XCTAssertNil(error)
            XCTAssertNotNil(drugs)
            XCTAssertEqual(drugs!.count, 1)
            XCTAssertEqual(drugs![0].active_principle, "paracetamol")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.testQuery, query)
            }
        }
        
    }

}
