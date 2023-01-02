import Foundation
import CoreData

@objc(Therapy)
class Therapy : NSManagedObject, Identifiable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
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
    
    func encode(with coder: NSCoder) {
        print(1)
        coder.encode(Int32(self.id), forKey: "id")
        coder.encode(self.name, forKey: "name")
        coder.encode(self.doctor != nil , forKey: "doctorNotNil")
        if self.doctor != nil{
            coder.encode(Int32(self.doctor!.id), forKey: "doctor.id")
            coder.encode(self.doctor!.name!, forKey: "doctor.name")
            coder.encode(self.doctor!.address!, forKey: "doctor.address")
        }
        coder.encode(self.duration, forKey: "duration")
        coder.encode(self.notes, forKey: "notes")
        
        var drugs_string: String = ""
        for d in drugs{
            drugs_string += String(d.id) + ";" + d.group_description + ";" + d.ma_holder + ";" + d.equivalence_group_code + ";" + d.denomination_and_packaging + ";" + d.active_principle + ";" + d.ma_code + "|"
        }
        
        coder.encode(drugs_string, forKey: "drugs")
        
        var interactions_string: String = ""
        for i in interactions{
            interactions_string += i + "|"
        }
        
        coder.encode(interactions_string, forKey:"interactions")
    }
    
    required convenience init?(coder: NSCoder) {
        guard let id = Int16(coder.decodeInt32(forKey: "id")) as? Int16,
              let name = coder.decodeObject(of: NSString.self, forKey: "name") as? String,
              let doctorNotNil = coder.decodeBool(forKey: "doctorNotNil") as? Bool,
              let duration = coder.decodeObject(of: NSString.self, forKey: "duration") as? String,
              let notes = coder.decodeObject(of: NSString.self, forKey: "notes")as? String,
              let drugs_string = coder.decodeObject(of:NSString.self, forKey: "drugs") as? String,
              let interactions_string = coder.decodeObject(forKey: "interactions") as? String
        else{
            return nil
        }
        var doctor: Doctor? = nil
        if doctorNotNil == true{
            guard let doctor_id = Int16(coder.decodeInt32(forKey: "doctor.id")) as? Int16,
                  let doctor_name = coder.decodeObject(of: NSString.self, forKey: "doctor.name") as String?,
                  let doctor_address = coder.decodeObject(of: NSString.self, forKey: "doctor.address") as? String
            else{
                return nil
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "Doctor", in: CoreDataHelper.shared.context)!
            
            doctor = Doctor(entity: entity, insertInto: CoreDataHelper.shared.context)
            doctor!.name = doctor_name
            doctor!.address = doctor_address
            doctor!.id = Int16(doctor_id)
        }
        
        var drugs: [Drug] = []
        var drugs_parsed = drugs_string.components(separatedBy: "|")
        drugs_parsed.removeLast()
        for d in drugs_parsed{
                let entityDrug = NSEntityDescription.entity(forEntityName: "Drug", in: CoreDataHelper.shared.context)!
                let drug = Drug(entity: entityDrug, insertInto: CoreDataHelper.shared.context)
                drug.id = Int16(Int(d.components(separatedBy: ";")[0].trimmingCharacters(in: .whitespacesAndNewlines))!)
                drug.group_description = d.components(separatedBy: ";")[1]
                drug.ma_holder = d.components(separatedBy: ";")[2]
                drug.equivalence_group_code = d.components(separatedBy: ";")[3]
                drug.denomination_and_packaging = d.components(separatedBy: ";")[4]
                drug.active_principle = d.components(separatedBy: ";")[5]
                drug.ma_code = d.components(separatedBy: ";")[6]
                drugs.append(drug)
        }
        
        var interactions: [String] = []
        
        if interactions_string != "" {
            var interactions_parsed = interactions_string.components(separatedBy: "|")
            interactions_parsed.removeLast()
            interactions = interactions_parsed
        }
        
        
        let entityTherapy = NSEntityDescription.entity(forEntityName: "Therapy", in: CoreDataHelper.shared.context)!
        self.init(entity: entityTherapy, insertInto: CoreDataHelper.shared.context)
        self.id = id
        self.name = name
        self.doctor = doctor
        self.duration  = duration
        self.drugs = Set.init(drugs)
        self.notes = notes
        self.interactions = interactions
        
    }
}
