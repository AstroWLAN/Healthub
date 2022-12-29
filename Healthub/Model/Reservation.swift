//
//  Reservation.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/11/22.
//

import Foundation
import CoreData
@objc(Reservation)

class Reservation: NSManagedObject, Identifiable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    @NSManaged var id : Int16
    @NSManaged var date: Date
    @NSManaged var time: Date
    @NSManaged var doctor : Doctor
    @NSManaged var examinationType: ExaminationType
    /*func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }*/
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        print(1)
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.time, forKey: "time")
        coder.encode(self.doctor.id, forKey: "doctor.id")
        coder.encode(self.doctor.name!, forKey: "doctor.name")
        coder.encode(self.doctor.address!, forKey: "doctor.address")
        coder.encode(self.examinationType.id, forKey: "examinationType.id")
        coder.encode(self.examinationType.name, forKey: "examinationType.name")
        coder.encode(self.examinationType.duration_in_minutes, forKey: "examinationType.duration")
    }
    
    /*init(id: Int, date: Date, time: Date, doctor: Doctor, examinationType: ExaminationType) {
        self.id = id
        self.date = date
        self.time = time
        self.doctor = doctor
        self.examinationType = examinationType
    }*/
    
    
    required convenience init?(coder: NSCoder) {
        guard let id = coder.decodeInteger(forKey: "id") as? Int,
              let date = coder.decodeObject(of: NSDate.self, forKey: "date") as? Date,
              let time = coder.decodeObject(of: NSDate.self, forKey: "time") as? Date,
              let doctor_id = coder.decodeInteger(forKey: "doctor.id") as? Int,
              let doctor_name = coder.decodeObject(of: NSString.self, forKey: "doctor.name") as String?,
              let doctor_address = coder.decodeObject(of: NSString.self, forKey: "doctor.address") as? String,
              let examinationType_id = coder.decodeInteger(forKey: "examinationType.id") as? Int,
              let examinationType_name = coder.decodeObject(of: NSString.self, forKey: "examinationType.name")as? String,
              let examinationType_duration = coder.decodeInteger(forKey: "examinationType.duration") as? Int
        else{
            return nil
        }
       
        let entity = NSEntityDescription.entity(forEntityName: "Doctor", in: CoreDataHelper.shared.context)!
        let doctor = Doctor(entity: entity, insertInto: CoreDataHelper.shared.context)
        doctor.name = doctor_name
        doctor.address = doctor_address
        doctor.id = Int16(doctor_id)
        
        self.init()
        self.id = Int16(id)
        self.date = date
        self.doctor = doctor
        
        let entityExamination = NSEntityDescription.entity(forEntityName: "ExaminationType", in: CoreDataHelper.shared.context)!
        self.examinationType = ExaminationType(entity: entityExamination, insertInto: CoreDataHelper.shared.context)//(id: examinationType_id, name: examinationType_name, duration_in_minutes: examinationType_duration)
        self.examinationType.id = Int16(examinationType_id)
        self.examinationType.name = examinationType_name
        self.examinationType.duration_in_minutes = Int16(examinationType_duration)
        
        /*self.init(id: id, date: date, time: time, doctor: doctor, examinationType: ExaminationType(id: examinationType_id, name: examinationType_name, duration_in_minutes: examinationType_duration))*/
              
    }
    
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        lhs.id == rhs.id
    }
}

