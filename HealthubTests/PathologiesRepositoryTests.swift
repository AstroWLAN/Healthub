//
//  PathologiesRepositoryTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import XCTest
import CoreData
@testable import Healthub
import SwiftKeychainWrapper
final class PathologiesRepositoryTests: XCTestCase {
    
    private var pathologiesRepository: PathologyRepository!
    private var mockClient: MockClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClient = MockClient()
        pathologiesRepository = PathologyRepository(client: mockClient, dbHelper: MockDBHelper())
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
    
    func testAddOneElement(){
        //test
        let exp = expectation(description: "Add Pathology")
        let entity = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology = Pathology(entity: entity, insertInto: nil)
        pathology.id = 0
        pathology.name = "Pathology1"
        
        XCTAssertEqual(self.mockClient.pathologies.count, 0)
        
        pathologiesRepository.add(pathologyName: pathology.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 1)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology1")
                XCTAssertEqual(self.mockClient.pathologies.count, 1)
            }
        }
        
        }
    
    func testAddTwoElements(){
        let exp = expectation(description: "Add Pathology")
        let entity = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology = Pathology(entity: entity, insertInto: nil)
        pathology.id = 0
        pathology.name = "Pathology1"
        
        XCTAssertEqual(self.mockClient.pathologies.count, 0)
        
        pathologiesRepository.add(pathologyName: pathology.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 1)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology1")
                XCTAssertEqual(self.mockClient.pathologies.count, 1)
            }
        }
        
        let exp1 = expectation(description: "Add Pathology 2")
        let entity2 = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology1 = Pathology(entity: entity2, insertInto: nil)
        pathology1.id = 0
        pathology1.name = "Pathology2"
        
        pathologiesRepository.add(pathologyName: pathology1.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp1.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 2)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology2")
                XCTAssertEqual(self.mockClient.pathologies.count, 2)
            }
        }
    }
    
    func testDelete(){
        //test
        let exp = expectation(description: "Test Delete: Add One Element")
        
        XCTAssertEqual(self.mockClient.pathologies.count, 0)
        
        //let pathology = Pathology(id: 1, name: "Pathology")
        let entity = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology = Pathology(entity: entity, insertInto: nil)
        pathology.id = 1
        pathology.name = "Pathology"
        
        pathologiesRepository.add(pathologyName: pathology.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 1)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology")
                XCTAssertEqual(self.mockClient.pathologies.count, 1)
                
            }
        }
        
        let exp1 = expectation(description: "Test delete")
        let entity2 = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathologyToDelete = Pathology(entity: entity2, insertInto: nil)
        pathologyToDelete.id = 1
        pathologyToDelete.name = "Pathology"

        pathologiesRepository.delete(pathologyId: Int(pathologyToDelete.id)){(success, error) in
            XCTAssertTrue(success!, "it was not possible to delete pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp1.fulfill()
            
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 1)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology")
                XCTAssertEqual(self.mockClient.pathologies.count, 0)
            }
        }
        
        
        
    }
    
    func testDeleteOneElementFromArrayOfTwo(){
        let exp = expectation(description: "Add Pathology")
        let entity = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology = Pathology(entity: entity, insertInto: nil)
        pathology.id = 0
        pathology.name = "Pathology1"
        
        XCTAssertEqual(self.mockClient.pathologies.count, 0)
        
        pathologiesRepository.add(pathologyName: pathology.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.5) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 1)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology1")
                XCTAssertEqual(self.mockClient.pathologies.count, 1)
            }
        }
        
        let exp1 = expectation(description: "Add Pathology")
        let entity2 = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology1 = Pathology(entity: entity2, insertInto: nil)
        pathology1.id = 1
        pathology1.name = "Pathology2"
        
        pathologiesRepository.add(pathologyName: pathology1.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp1.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 2)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology2")
                XCTAssertEqual(self.mockClient.pathologies.count, 2)
            }
        }
        
        let exp2 = expectation(description: "Test delete")
        let entity3 = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathologyToDelete = Pathology(entity: entity3, insertInto: nil)
        pathologyToDelete.id = 1
        pathologyToDelete.name = "Pathology2"
        pathologiesRepository.delete(pathologyId: Int(pathologyToDelete.id)){(success, error) in
            XCTAssertTrue(success!, "it was not possible to delete pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp2.fulfill()
            
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 2)
                XCTAssertEqual(self.mockClient.pathologies.count, 1)
                XCTAssertEqual(self.mockClient.numberDeletePathology, 1)
            }
        }
        
        
    }
    
    func testGetAll(){
        //test
        let exp = expectation(description: "Test GetAll")
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil.\(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 0)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetPathologies, 1)
            }
        }
        
        let exp1 = expectation(description: "Test GetAll: add a pathology ")
        let entity4 = NSEntityDescription.entity(forEntityName: "Pathology", in: Healthub.CoreDataHelper.context)!
        let pathology = Pathology(entity: entity4, insertInto: nil)
        pathology.id = 1
        pathology.name = "Pathology"
        pathologiesRepository.add(pathologyName: pathology.name){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            exp1.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberAddPathology, 1)
                XCTAssertEqual(self.mockClient.addPathology.name, "Pathology")
            }
        }
        
        let exp2 = expectation(description: "Test GetAll: Get Again")
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 1)
            XCTAssertEqual(pathologies![0].name, "Pathology")
            exp2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberGetPathologies, 2)
            }
        }
}
        
        
        
        
    

}
