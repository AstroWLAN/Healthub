//
//  User.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
class Patient: ObservableObject{
    @Published var email: String
    @Published var name: String
    @Published var sex: Genders
    @Published var dateOfBirth: Date
    @Published var fiscalCode: String
    @Published var height: Int
    @Published var weight: Float
    @Published var phone: String
    
    init(email:String, name: String, sex: Genders, dateOfBirth: Date, fiscalCode: String, height: Int, weight: Float, phone: String) {
        self.email = email
        self.name = name
        self.sex = sex
        self.dateOfBirth = dateOfBirth
        self.fiscalCode = fiscalCode
        self.height = height
        self.weight = weight
        self.phone = phone
    }
    
}
