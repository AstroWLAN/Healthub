//
//  ProfileViewModelintegrationTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class ProfileViewModelTestsIntegrationTests: XCTestCase {

    private var profileViewModel: Healthub.ProfileViewModel!
    private var userRepository: Healthub.UserRepository!
    private var clientAPI: MockClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let saveSuccessful: Bool = KeychainWrapper.standard.set("1234", forKey: "access_token")
        guard saveSuccessful == true else{
            preconditionFailure("Unable to save access_token to keychain")
        }
        clientAPI = MockClient()
        userRepository = Healthub.UserRepository(client: clientAPI, dbHelper: MockDBHelper())
        profileViewModel = Healthub.ProfileViewModel(userRepository: userRepository, connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        guard removeSuccessful == true else{
            preconditionFailure("Unable to remove access_token from keychain")
        }
    }

    func testGetPatient(){
        
        let expectation = XCTestExpectation(description: "Object's property should change")
        profileViewModel.getPatient(force_reload: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.profileViewModel.patient?.email, "dispoto97@gmail.com")
            XCTAssertEqual(self.profileViewModel.patient?.name, "Giovanni Dispoto")
            XCTAssertEqual(self.clientAPI.numberGetUser, 1)
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testUpdatePatient(){
        
        let expectation = XCTestExpectation(description: "Object's property should change")
        profileViewModel.getPatient(force_reload: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.profileViewModel.patient?.email, "dispoto97@gmail.com")
            XCTAssertEqual(self.profileViewModel.patient?.name, "Giovanni Dispoto")
            XCTAssertEqual(self.clientAPI.numberGetUser, 1)
            expectation.fulfill()
            }
       
        wait(for: [expectation], timeout: 1.0)
        
        profileViewModel.getPatient()
        
        profileViewModel.name = "Test"
        profileViewModel.gender = Gender.other
        profileViewModel.height = "173"
        profileViewModel.weight = "75"
        profileViewModel.birthday = Date()
        profileViewModel.fiscalCode = "FISCALCODE"
        profileViewModel.phone = "1234"
        
        
        let expectation2 = XCTestExpectation(description: "Object's property should change")
        profileViewModel.updatePatient()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            
            XCTAssertEqual(self.profileViewModel.name, "Test")
            XCTAssertEqual(self.profileViewModel.gender, Gender.other)
            XCTAssertEqual(self.profileViewModel.height, "173")
            

            expectation2.fulfill()
        }
       
        wait(for: [expectation2], timeout: 3.0)
        
        
        
    
        
    }

}
