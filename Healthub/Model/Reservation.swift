//
//  Reservation.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/11/22.
//

import Foundation
struct Reservation: Identifiable, Hashable {
    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        lhs.id == rhs.id
    }
    
    //let id: UUID = UUID()
    private(set) var id : Int
    private(set) var date: Date
    private(set) var time: Date
    private(set) var doctor : Doctor
    private(set) var examinationType: ExaminationType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


