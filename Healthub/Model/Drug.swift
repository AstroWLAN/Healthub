import Foundation
import CoreData

class Drug :NSManagedObject, Identifiable {
    @NSManaged var id: Int16
    @NSManaged var group_description: String
    @NSManaged var ma_holder: String
    @NSManaged var equivalence_group_code: String
    @NSManaged var denomination_and_packaging: String
    @NSManaged var active_principle: String
    @NSManaged var ma_code: String
}
