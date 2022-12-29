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
            coder.encode(self.id, forKey: "id")
            coder.encode(self.name, forKey: "name")
            coder.encode(self.address, forKey: "address")
        }
    
    public required convenience init?(coder: NSCoder) {
        guard let id = coder.decodeInteger(forKey: "id") as? Int,
              let name = coder.decodeObject(of: NSString.self, forKey: "name") as? String,
              let address = coder.decodeObject(of: NSString.self, forKey: "address") as? String
        else{
            return nil
        }
       // self.init(id: id, name: name, address: address)
        self.init()
        self.id = Int16(id)
        self.name = name
        self.address = address
              
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
