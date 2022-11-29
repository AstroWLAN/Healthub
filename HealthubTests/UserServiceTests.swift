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
    private var mockClient: MockClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockClient = MockClient()
        userService = UserService(client: mockClient)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoLogin(){
        let exp = expectation(description:"Test Login")
        
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
            XCTAssertEqual(KeychainWrapper.standard.string(forKey: "access_token"), "1234")
            XCTAssertNotEqual(KeychainWrapper.standard.string(forKey: "access_token"), "access_token")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
            }
        }
        
    }
    
    func testDoLogout(){
        
        let exp = expectation(description:"Test Logout")
        
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
            }
        }
        
        let exp1 = expectation(description:"Test Logout")
        
        userService.doLogout(){(success, error) in
            XCTAssertTrue(success!, "success is null")
            XCTAssertNotEqual(KeychainWrapper.standard.string(forKey: "access_token"), "1234", "access token still set")
            XCTAssertNil(KeychainWrapper.standard.string(forKey: "access_token"), "access_token is not null")
            exp1.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
                XCTAssertEqual(self.mockClient.numberLogout, 1)
            }
        }
    }
    
    func testGetUser(){
        let exp = expectation(description:"Test Get user")
        
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
            }
        }
        
        let exp1 = expectation(description:"Test Get user")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        userService.getUser(){(patient, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertEqual(patient?.email, "dispoto97@gmail.com")
            XCTAssertEqual(patient?.name, "Giovanni Dispoto")
            XCTAssertEqual(patient?.dateOfBirth, formatter.date(from: "1997-09-18"))
            exp1.fulfill()
            
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
                XCTAssertEqual(self.mockClient.numberGetUser, 1)
            }
        }
        
    }
    
    func testUpdateUserInformation(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let exp = expectation(description: "Test Update User: Login")
        
        userService.doLogin(email: "dispoto97@gmail.com", password: "StrongPassword00"){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success is null")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
                XCTAssertNotNil(KeychainWrapper.standard.string(forKey: "access_token"), "access_token is null")
            }
        }
        
        let exp1 = expectation(description: "Test Update User: update")
        
        let patient = Patient(email: "dispoto97@gmail.com", name: "Dario Crippa", sex: .Male, dateOfBirth: formatter.date(from: "1997-08-18")!, fiscalCode: "DSPGNN97P18L113H", height: 176, weight: 76, phone: "+393318669067")
        
        userService.updateInformation(user: patient){ (success, error) in
            XCTAssertNil(error, "Error is not null")
            XCTAssertTrue(success!, "Success it not true")
            exp1.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectation errored: \(error)")
            }else{
                XCTAssertEqual(self.mockClient.numberLogin, 1)
                XCTAssertNotNil(KeychainWrapper.standard.string(forKey: "access_token"), "access_token is null")
                XCTAssertNotNil(self.mockClient.updatePatient)
                XCTAssertEqual(self.mockClient.updatePatient.name, "Dario Crippa")
                XCTAssertEqual(self.mockClient.updatePatient.fiscalCode, "DSPGNN97P18L113H")
                XCTAssertEqual(self.mockClient.updatePatient.weight, 76)
                XCTAssertEqual(self.mockClient.updatePatient.dateOfBirth, "1997-08-18" )
            }
        }
        
        
        
    }

}
