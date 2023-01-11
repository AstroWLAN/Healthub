//
//  TherapyViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import SwiftKeychainWrapper
@testable import Healthub

final class TherapyViewModelTests: XCTestCase {
    
    private var therapyViewModel: Healthub.TherapyViewModel!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        therapyViewModel = Healthub.TherapyViewModel(therapyRepository: MockTherapyRepository(), connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
    }


    func testFetchDrugList(){}
    
    func testFetchTherapies(){
        therapyViewModel.fetchTherapies()
        
        XCTAssertEqual(therapyViewModel.therapies.count, 1)
        XCTAssertEqual(therapyViewModel.therapies[0].name, "therapy 1")
        XCTAssertEqual(therapyViewModel.therapies[0].drugs.count, 1)
        
        
    }
    
    func testCreateNewTherapy(){}
    
    func testDeelteTherapy(){}

}
