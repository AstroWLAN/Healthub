//
//  SignUpViewModelIntegrationTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import CoreData
import SwiftKeychainWrapper
@testable import Healthub


final class SignUpViewModelIntegrationTests: XCTestCase {

    private var signUpViewModel: Healthub.SignUpViewModel!
    private var userRepository: Healthub.UserRepository!
    private var clientAPI: MockClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clientAPI = MockClient()
        userRepository = Healthub.UserRepository(client: clientAPI, dbHelper: MockDBHelper())
        signUpViewModel = Healthub.SignUpViewModel(userRepository: userRepository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRecover(){
        let email = "test@test.it"
        signUpViewModel.recover(email: email)
        
        XCTAssertEqual(clientAPI.testEmail, email)
        XCTAssertEqual(clientAPI.numberRecover, 1)
        
        
        
    }
    
    func testSignUp(){
        let email = "test@test.it"
        let password = "test"
        signUpViewModel.signUp(email: email, password: password)
        XCTAssertEqual(clientAPI.testEmail, email)
        XCTAssertEqual(clientAPI.testPassword, password)
        
    }

    

}
