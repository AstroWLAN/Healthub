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
    func getDoctorsByExamName(exam_name: String, completionHandler: @escaping ([Doctor]?, Error?) -> Void)
    func getAvailableSlots(date: Date, doctor_id: Int, examinationType_id: Int,  completionHandler: @escaping ([String]?, Error?) -> Void)
    func addReservation(date: Date, starting_time: String, doctor_id: Int, examinationType: Int, completionHandler:  @escaping (Bool?, Error?) -> Void )
    
    func deleteReservation(reservation_id: Int, completionHandler:  @escaping (Bool?, Error?) -> Void)
}
