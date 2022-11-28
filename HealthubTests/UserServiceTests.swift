//
//  UserServiceTests.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import XCTest
import SwiftKeychainWrapper
@testable import Healthub

final class UserServiceTests: XCTestCase {
    
    private var userService: UserService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userService = UserService(client: MockClient())
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoLogin(){
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
            XCTAssertEqual(KeychainWrapper.standard.string(forKey: "access_token"), "1234")
            XCTAssertNotEqual(KeychainWrapper.standard.string(forKey: "access_token"), "access_token")
        }
        
    }
    
    func testDoLogout(){
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
        }
        
        userService.doLogout(){(success, error) in
            XCTAssertTrue(success!, "success is null")
            XCTAssertNotEqual(KeychainWrapper.standard.string(forKey: "access_token"), "1234", "access token still set")
            XCTAssertNil(KeychainWrapper.standard.string(forKey: "access_token"), "access_token is not null")
        }
    }
    
    func testGetUser(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        userService.getUser(){(patient, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertEqual(patient?.email, "dispoto97@gmail.com")
            XCTAssertEqual(patient?.name, "Giovanni Dispoto")
            XCTAssertEqual(patient?.dateOfBirth, formatter.date(from: "1997-09-18"))
            
        }
    }
    
    func testUpdateUserInformation(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
        }
        
        XCTAssertNotNil(KeychainWrapper.standard.string(forKey: "access_token"), "access_token is null")
        
        let patient = Patient(email: "dispoto97@gmail.com", name: "Giovanni Dispoto", sex: .Male, dateOfBirth: formatter.date(from: "1997-09-18")!, fiscalCode: "DSPGNN97P18L113H", height: 176, weight: 76, phone: "+393318669067")
        
        userService.updateInformation(user: patient){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success it not true")
        }
        
    }

}
