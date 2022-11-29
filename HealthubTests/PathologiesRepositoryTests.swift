//
//  PathologiesRepositoryTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import XCTest
@testable import Healthub
final class PathologiesRepositoryTests: XCTestCase {
    
    private var pathologiesRepository: PathologiesRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        pathologiesRepository = PathologiesRepository(client: MockClient())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAdd(){
        //test
        let pathology = Pathology(id: 0, name: "Pathology")
        pathologiesRepository.add(pathology){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            
        }
        }
    
    func testDelete(){
        //test
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil.\(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 0)
        }
        
        let pathology = Pathology(id: 1, name: "Pathology")
        
        pathologiesRepository.add(pathology){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            
        }
        
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 1)
            XCTAssertEqual(pathologies![0].name, "Pathology")
        }
        
        pathologiesRepository.delete(pathology){(success, error) in
            XCTAssertTrue(success!, "it was not possible to delete pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            
        }
        
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 1)
        }
        
        
    }
    
    func getAll(){
        //test
        
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil.\(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 0)
        }
        
        let pathology = Pathology(id: 1, name: "Pathology")
        pathologiesRepository.add(pathology){ (success, error) in
            XCTAssertTrue(success!, "it was not possible to add pathology")
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            
        }
        
        pathologiesRepository.getAll(){ (pathologies, error) in
            XCTAssertNil(error, "Error not nil. \(String(describing: error?.localizedDescription))")
            XCTAssertEqual(pathologies!.count, 1)
            XCTAssertEqual(pathologies![0].name, "Pathology")
        }
}
        
        
        
        
    

}
