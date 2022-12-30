//
//  UserServiceProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 28/11/22.
//

import Foundation

protocol UserRepositoryProtocol{
    func updateInformation(user: Patient, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getUser(force_reload: Bool, completionHandler: @escaping (Patient?, Error?) -> Void)
    func doLogin(email: String, password: String, completionHandler: @escaping (Bool?, API.Types.Error?) -> Void)
    func doLogout(completionHandler: @escaping (Bool?, Error?) -> Void)
    func registerUser(email: String, password: String, completionHandler: @escaping (Bool?, API.Types.Error?) -> Void)
}
