//
//  PathologyViewModelIntegrationTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class PathologyViewModelIntegrationTests: XCTestCase {
    
    private var pathologyViewModel: Healthub.PathologyViewModel!
    private var pathologyRepository: Healthub.PathologyRepository!
    private var clientAPI: MockClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
        clientAPI = MockClient()
        pathologyRepository = Healthub.PathologyRepository(client: clientAPI, dbHelper: MockDBHelper())
        pathologyViewModel = Healthub.PathologyViewModel(pathologyRepository: pathologyRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }


    func testFetchPathologies(){
        
        let expectation = XCTestExpectation(description: "Object's property should change")
        pathologyViewModel.fetchPathologies(force_reload: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.pathologyViewModel.pathologies.count, 2)
            XCTAssertEqual(self.pathologyViewModel.pathologies[0].name, "pathology A")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 2.0)
        
        
        
    }
    
    func testAddPathology(){
        let pathology = "pathologyTest"
        let expectation = XCTestExpectation(description: "Object's property should change")
        pathologyViewModel.addPathology(pathology: pathology)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.addPathology.name, pathology)
            
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testRemovePathology(){
        let expectation = XCTestExpectation(description: "Object's property should change")
        pathologyViewModel.fetchPathologies(force_reload: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.pathologyViewModel.pathologies.count, 2)
            XCTAssertEqual(self.pathologyViewModel.pathologies[0].name, "pathology A")
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
        let position = 0
        let expectation2 = XCTestExpectation(description: "Object's property should change")
        pathologyViewModel.removePathology(at: position)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.clientAPI.deletedPathologyId, 1)
            
            expectation2.fulfill()
            }
       
        wait(for: [expectation2], timeout: 1.0)
    }
    

}
