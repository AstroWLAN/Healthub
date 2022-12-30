import Foundation
import CoreData

class Pathology : NSManagedObject {
    
    @NSManaged var id : Int16
    @NSManaged var name : String
}
