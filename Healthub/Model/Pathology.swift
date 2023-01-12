import Foundation
import CoreData

class Pathology : NSManagedObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    @NSManaged var id : Int16
    @NSManaged var name : String
    
    func encode(with coder: NSCoder) {
        coder.encode(Int32(self.id), forKey: "id")
        coder.encode(self.name, forKey: "name")
    }
    
    required convenience init?(coder: NSCoder) {
        guard let id = Int16(coder.decodeInt32(forKey: "id")) as? Int16,
              let name = coder.decodeObject(of: NSString.self, forKey: "name") as? String
        else{
            return nil
        }
       // self.init(id: id, name: name, address: address)
        let entity = NSEntityDescription.entity(forEntityName: "Pathology", in: CoreDataHelper.context)!
        self.init(entity: entity, insertInto: CoreDataHelper.context)
        self.id = Int16(id)
        self.name = name
    }
}
