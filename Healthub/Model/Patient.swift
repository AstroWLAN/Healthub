//
//  User.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

import Foundation
import CoreData

@objc(Patient)
class Patient: NSManagedObject, NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var sex: Int16
    @NSManaged var dateOfBirth: Date
    @NSManaged var fiscalCode: String
    @NSManaged var height: Int16
    @NSManaged var weight: Float
    @NSManaged var phone: String
    
    
    func encode(with coder: NSCoder) {
        coder.encode(self.email, forKey: "email")
        coder.encode(self.name, forKey: "name")
        coder.encode(Int32(self.sex), forKey: "sex")
        coder.encode(self.dateOfBirth, forKey: "dateOfBirth")
        coder.encode(self.fiscalCode, forKey: "fiscalCode")
        coder.encode(Int32(self.height), forKey: "height")
        coder.encode(self.weight, forKey:"weight")
        coder.encode(self.phone, forKey: "phone")
        
        }
    
    public required convenience init?(coder: NSCoder) {
        guard let email = coder.decodeObject(of: NSString.self, forKey: "email") as? String,
              let name = coder.decodeObject(of: NSString.self, forKey: "name") as? String,
              let sex = coder.decodeInt32(forKey: "sex") as? Int32,
              let dateOfBirth = coder.decodeObject(of: NSDate.self, forKey: "dateOfBirth") as? Date,
              let fiscalCode = coder.decodeObject(of: NSString.self, forKey: "fiscalCode") as? String,
              let height = coder.decodeInt32(forKey: "height") as? Int32,
              let weight = coder.decodeFloat(forKey: "weight") as? Float,
              let phone = coder.decodeObject(of: NSString.self, forKey: "phone") as? String
        else{
            return nil
        }
       // self.init(id: id, name: name, address: address)
        let entityPatient = NSEntityDescription.entity(forEntityName: "Patient", in: CoreDataHelper.context)!
        self.init(entity: entityPatient, insertInto: CoreDataHelper.context)
        self.email = email
        self.name = name
        self.sex = Int16(sex)
        self.dateOfBirth = dateOfBirth
        self.fiscalCode = fiscalCode
        self.height = Int16(height)
        self.weight = weight
        self.phone = phone
              
    }
    
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
