//
//  Doctor.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
import CoreLocation
import CoreData

@objc(Doctor)
class Doctor: NSManagedObject, NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    
    /*init(id: Int, name: String, address: String) {
        self.id = Int16(id)
        self.name = name
        self.address = address
    }*/
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Doctor> {
        return NSFetchRequest<Doctor>(entityName: "Doctor")
    }
    
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        lhs.id == rhs.id
    }
    
    func encode(with coder: NSCoder) {
            coder.encode(Int32(self.id), forKey: "id")
            coder.encode(self.name, forKey: "name")
            coder.encode(self.address, forKey: "address")
            coder.encode(self.phone, forKey: "phone")
            coder.encode(self.email, forKey: "email")
        }
    
    public required convenience init?(coder: NSCoder) {
        guard let id = Int16(coder.decodeInt32(forKey: "id")) as? Int16,
              let name = coder.decodeObject(of: NSString.self, forKey: "name") as? String,
              let address = coder.decodeObject(of: NSString.self, forKey: "address") as? String,
              let phone = coder.decodeObject(of: NSString.self, forKey: "phone") as? String,
              let email = coder.decodeObject(of: NSString.self, forKey: "email") as? String
        else{
            return nil
        }
       // self.init(id: id, name: name, address: address)
        let entity = NSEntityDescription.entity(forEntityName: "Doctor", in: CoreDataHelper.context)!
        self.init(entity: entity, insertInto: CoreDataHelper.context)
        self.id = Int16(id)
        self.name = name
        self.address = address
        self.phone = phone
        self.email = email
              
    }
  
   /* func getCoordinates(completion: @escaping (_ location: CLLocationCoordinate2D?, Error?)-> Void){
        Address2Coordinates.translate(from: self.address){ (coordinates, error) in
            if let coordinates = coordinates{
                completion(coordinates, nil)
            }else{
                completion(nil, error)
            }
            
        }
    }*/
}
