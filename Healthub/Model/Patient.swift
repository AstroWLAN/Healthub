//
//  User.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import CoreData

@objc(Patient)
class Patient: NSManagedObject{
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var sex: Int16
    @NSManaged var dateOfBirth: Date
    @NSManaged var fiscalCode: String
    @NSManaged var height: Int16
    @NSManaged var weight: Float
    @NSManaged var phone: String
    
    /*init(email:String, name: String, sex: Gender, dateOfBirth: Date, fiscalCode: String, height: Int, weight: Float, phone: String) {
        self.email = email
        self.name = name
        self.sex = sex
        self.dateOfBirth = dateOfBirth
        self.fiscalCode = fiscalCode
        self.height = height
        self.weight = weight
        self.phone = phone
    }*/
    
}
