//
//  LoginViewModelTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import XCTest
import SwiftKeychainWrapper
@testable import Healthub

final class LoginViewModelTests: XCTestCase {
    
    private var loginViewModel: Healthub.LoginViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginViewModel = Healthub.LoginViewModel(userRepository: MockUserRepository() as! Healthub.UserRepositoryProtocol)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
    }
    
    func testLogin(){
        loginViewModel.doLogin(email: "email", password: "password")
        
        XCTAssertNotNil(KeychainWrapper.standard.string(forKey: "access_token"))
        XCTAssertEqual(KeychainWrapper.standard.string(forKey: "access_token")!, "1234")
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isLogged"), true)
    }
    
    func testLogout(){
        loginViewModel.doLogin(email: "email", password: "password")
        
        loginViewModel.doLogout()
        
        XCTAssertNil(KeychainWrapper.standard.string(forKey: "access_token"))
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isLogged"), false)
        
    }
    
    }
   
