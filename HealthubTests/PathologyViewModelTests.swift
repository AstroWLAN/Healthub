//
//  PathologyViewModel.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class PathologyViewModelTests: XCTestCase {
    
    private var pathologyViewModel: Healthub.PathologyViewModel!
    private var pathologyRepository: MockPathologyRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        pathologyRepository = MockPathologyRepository()
        pathologyViewModel = Healthub.PathologyViewModel(pathologiesRepository: pathologyRepository ,connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testFetchPathologies(){
        pathologyViewModel.fetchPathologies(force_reload: true)
        
        XCTAssertEqual(pathologyViewModel.pathologies.count, 2)
        XCTAssertEqual(pathologyViewModel.pathologies[0].id, 1)
        XCTAssertEqual(pathologyViewModel.pathologies[0].name, "pathologyA")
        XCTAssertEqual(pathologyViewModel.pathologies[1].id, 2)
        XCTAssertEqual(pathologyViewModel.pathologies[1].name, "pathologyB")
        
    }
    
    func testAddPathology(){
        let pathology = "pathologyTest"
        pathologyViewModel.addPathology(pathology: pathology)
        
        XCTAssertEqual(pathologyRepository.testAddPathology, pathology)
        
    }
    
    func testRemovePathology(){
        let position = 0
        pathologyViewModel.fetchPathologies(force_reload: true)
        
        pathologyViewModel.removePathology(at: position)
        XCTAssertEqual(pathologyRepository.testRemoveId, 1)
    }
    

}
