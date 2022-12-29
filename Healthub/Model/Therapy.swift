import Foundation
import CoreData

@objc(Therapy)
class Therapy : NSManagedObject, Identifiable {
    @NSManaged var id: Int16
    @NSManaged var name: String
    // Può anche essere una stringa... basta il nome del medico
    @NSManaged var doctor: Doctor?
    @NSManaged var duration: String
    // Rendere drug un array ( ogni terapia può avere molteplici farmaci )
    // Può anche essere un array di stringhe... basta solo il nome del farmaco
    @NSManaged var drugs: Set<Drug>
    @NSManaged var notes: String
    @NSManaged var interactions: [String]
}
