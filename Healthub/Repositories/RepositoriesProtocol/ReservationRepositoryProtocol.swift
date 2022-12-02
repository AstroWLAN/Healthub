//
//  ReservationRepositoryProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation

protocol ReservationRepositoryProtocol
{
    func add(date: Date, doctor_id: Int, examinationType: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    func delete(reservation_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void)
    func getAll(completionHandler: @escaping ([Reservation]?, Error?) -> Void)
    
    
    
}
