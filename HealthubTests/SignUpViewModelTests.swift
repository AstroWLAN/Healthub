//
//  SignUpViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 11/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub


final class SignUpViewModelTests: XCTestCase {

    private var signUpViewModel: Healthub.SignUpViewModel!
    private var userRepository: MockUserRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userRepository = MockUserRepository()
        signUpViewModel = Healthub.SignUpViewModel(userRepository: userRepository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecover(){
        let email = "test@test.it"
        signUpViewModel.recover(email: email)
        
        XCTAssertEqual(userRepository.testRecoverEmail, email)
        
        
    }
    
    func testSignUp(){
        let email = "test@test.it"
        let password = "test"
        signUpViewModel.signUp(email: email, password: password)
        XCTAssertEqual(userRepository.testRegisterEmail, email)
        XCTAssertEqual(userRepository.testRegisterPassword, password)
        
    }

    

}
