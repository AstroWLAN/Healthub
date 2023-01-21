//
//  LoginViewModel.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 21/01/23.
//

import XCTest
import SwiftKeychainWrapper
@testable import Healthub

final class LoginViewModelIntegrationTests: XCTestCase {
    
    private var loginViewModel: Healthub.LoginViewModel!
    private var userRepository: Healthub.UserRepository!
    private var clientAPI: MockClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clientAPI = MockClient()
        userRepository = Healthub.UserRepository(client: clientAPI, dbHelper: MockDBHelper() )
        loginViewModel = Healthub.LoginViewModel(userRepository: MockUserRepository() as! Healthub.UserRepositoryProtocol)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.set(false, forKey: "isLogged")
    }
    
    func testLogin(){
        loginViewModel.doLogin(email: "email", password: "password")
        XCTAssertNotNil(KeychainWrapper.standard.string(forKey: "access_token"))
        XCTAssertEqual(KeychainWrapper.standard.string(forKey: "access_token")!, "1234")
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isLogged"), true)
    }
    
    func testLoginWithError(){
        loginViewModel.doLogin(email: "email2", password: "password")
        
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isLogged"), false)
        XCTAssertEqual(loginViewModel.hasError, true)
    }
    
    func testLogout(){
        loginViewModel.doLogin(email: "email", password: "password")
        
        loginViewModel.doLogout()
        
        XCTAssertNil(KeychainWrapper.standard.string(forKey: "access_token"))
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "isLogged"), false)
        
    }
    
}
   
