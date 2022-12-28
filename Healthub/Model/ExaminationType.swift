//
//  ExamType.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
class ExaminationType:NSObject, NSSecureCoding{
    static var supportsSecureCoding: Bool = true
    
    private(set) var id: Int
    private(set) var name: String
    private(set) var duration_in_minutes: Int
    
    init(id: Int, name: String, duration_in_minutes: Int) {
        self.id = id
        self.name = name
        self.duration_in_minutes = duration_in_minutes
    }
    
    static func == (lhs: ExaminationType, rhs: ExaminationType) -> Bool {
        lhs.id == rhs.id
    }
    
    func encode(with coder: NSCoder) {
        func encode(with coder: NSCoder) {
            coder.encode(self.id, forKey: "id")
            coder.encode(self.name, forKey: "name")
            coder.encode(self.duration_in_minutes, forKey: "duration_in_minutes")
        }
    }
    
   /* func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }*/
    
    required convenience init?(coder: NSCoder) {
        guard let id = coder.decodeInteger(forKey: "id") as? Int,
              let name = coder.decodeObject(of: NSString.self, forKey: "name") as? String,
              let duration = coder.decodeObject(of: NSString.self, forKey: "duration_in_minutes") as? Int
        else{
            return nil
        }
        self.init(id: id, name: name, duration_in_minutes: duration)
              
    }
    
}
