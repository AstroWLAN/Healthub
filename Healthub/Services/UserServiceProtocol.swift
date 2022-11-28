//
//  UserServiceProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import Foundation

protocol UserServiceProtocol{
    func updateInformation(user: Patient, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getUser(completionHandler: @escaping (Patient?, Error?) -> Void)
    func registerUser()
    func doLogin(email: String, password: String, completionHandler: @escaping (Bool?, API.Types.Error?) -> Void)
    func doLogout(completionHandler: @escaping (Bool?, Error?) -> Void)
}
