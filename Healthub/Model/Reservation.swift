//
//  Reservation.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/11/22.
//

import Foundation
class Reservation: NSObject, Identifiable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    private(set) var id : Int
    private(set) var date: Date
    private(set) var time: Date
    private(set) var doctor : Doctor
    private(set) var examinationType: ExaminationType
    
    /*func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }*/
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.date, forKey: "date")
        coder.encode(self.time, forKey: "time")
        coder.encode(self.doctor.id!, forKey: "doctor.id")
        coder.encode(self.doctor.name!, forKey: "doctor.name")
        coder.encode(self.doctor.address!, forKey: "doctor.address")
        coder.encode(self.examinationType.id, forKey: "examinationType.id")
        coder.encode(self.examinationType.name, forKey: "examinationType.name")
        coder.encode(self.examinationType.duration_in_minutes, forKey: "examinationType.duration")
    }
    
    init(id: Int, date: Date, time: Date, doctor: Doctor, examinationType: ExaminationType) {
        self.id = id
        self.date = date
        self.time = time
        self.doctor = doctor
        self.examinationType = examinationType
    }
    
    
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
        
        self.init(id: id, date: date, time: time, doctor: Doctor(id: doctor_id, name: doctor_name, address: doctor_address), examinationType: ExaminationType(id: examinationType_id, name: examinationType_name, duration_in_minutes: examinationType_duration))
              
    }
    
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        lhs.id == rhs.id
    }
}


