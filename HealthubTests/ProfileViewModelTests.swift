//
//  ProfileViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub

final class ProfileViewModelTests: XCTestCase {

    private var profileViewModel: Healthub.ProfileViewModel!
    private var userRepository: MockUserRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userRepository = MockUserRepository()
        profileViewModel = Healthub.ProfileViewModel(userService: userRepository, connectivityProvider: MockConnectivity(dbHelper: MockDBHelper()))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPatient(){
        profileViewModel.getPatient(force_reload: true)
        XCTAssertEqual(profileViewModel.name, "Peter Parker")
        XCTAssertEqual(profileViewModel.gender, Gender.male)
        XCTAssertEqual(profileViewModel.height, "178")
        
    }
    
    func testUpdatePatient(){
        
        profileViewModel.getPatient()
        
        profileViewModel.name = "Test"
        profileViewModel.gender = Gender.other
        profileViewModel.height = "173"
        profileViewModel.weight = "75"
        profileViewModel.birthday = Date()
        profileViewModel.fiscalCode = "FISCALCODE"
        profileViewModel.phone = "1234"
        profileViewModel.updatePatient()
        
        XCTAssertEqual(profileViewModel.name, "Test")
        XCTAssertEqual(profileViewModel.gender, Gender.other)
        XCTAssertEqual(profileViewModel.height, "173")
        
        XCTAssertEqual(userRepository.user.name, "Test")
        XCTAssertEqual(userRepository.user.sex, 2)
        XCTAssertEqual(userRepository.user.height, 173)
        
    }

}
