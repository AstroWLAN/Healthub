//
//  MockReservationRepository.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 12/01/23.
//

import Foundation
import SwiftKeychainWrapper
import CoreData
@testable import Healthub

class MockReservationRepository: Healthub.ReservationRepositoryProtocol{
    
    private(set) var reservations: [Healthub.Reservation] = []
    private(set) var testGetDoctorByExamName: String = ""
    private(set) var testFetchSlotDoctorId: Int = 0
    private(set) var testFetchSlotExaminationType_id: Int = 0
    private(set) var testFetchSlotDate: Date = Date()
    private(set) var testAddReservationDate: Date = Date()
    private(set) var testAddReservationStartingTime: String = ""
    private(set) var testAddReservationDoctorId: Int = 0
    private(set) var testAddReservationExaminationType_id: Int = 0
    private(set) var testDeletionReservationId: Int = 0
    private(set) var testGetAvailableDateDoctorId: Int = 0
    
    
    init(){
        let entityDoctor = NSEntityDescription.entity(forEntityName: "Doctor", in: Healthub.CoreDataHelper.context)!
        let doctor = Healthub.Doctor(entity: entityDoctor, insertInto: nil)
        doctor.id = 1
        doctor.name = "A"
        doctor.email = "A"
        doctor.address = "A"
        doctor.phone = "A"
        
        let entityExaminationType = NSEntityDescription.entity(forEntityName: "ExaminationType", in: Healthub.CoreDataHelper.context)!
        let examination1 = Healthub.ExaminationType(entity: entityExaminationType, insertInto: nil)
        examination1.id = 1
        examination1.name = "vaccination"
        
        let examination2 = Healthub.ExaminationType(entity: entityExaminationType, insertInto: nil)
        examination2.id = 1
        examination2.name = "specialist"
        
        let entityReservation = NSEntityDescription.entity(forEntityName: "Reservation", in: Healthub.CoreDataHelper.context)!
        let reservation1 = Healthub.Reservation(entity: entityReservation, insertInto: nil)
        reservation1.id = 1
        reservation1.date = Date.now
        reservation1.time = Date.now
        reservation1.doctor = doctor
        reservation1.examinationType = examination1
        
        reservations.append(reservation1)
        
        let reservation2 = Healthub.Reservation(entity: entityReservation, insertInto: nil)
        reservation2.id = 2
        reservation2.date = Date.now
        reservation2.time = Date.now
        reservation2.doctor = doctor
        reservation2.examinationType = examination2
        
        reservations.append(reservation2)
        
    }
    
    func add(date: Date, doctor_id: Int, examinationType: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        
    }
    
    func getAll(force_reload: Bool, completionHandler: @escaping ([Healthub.Reservation]?, Error?) -> Void) {
        completionHandler(reservations, nil)
    }
    
    func getDoctorsByExamName(exam_name: String, completionHandler: @escaping ([Healthub.Doctor]?, Error?) -> Void) {
        self.testGetDoctorByExamName = exam_name
        let entityDoctor = NSEntityDescription.entity(forEntityName: "Doctor", in: Healthub.CoreDataHelper.context)!
        let doctor = Healthub.Doctor(entity: entityDoctor, insertInto: nil)
        doctor.id = 1
        doctor.name = "A"
        doctor.email = "A"
        doctor.address = "A"
        doctor.phone = "A"
        var doctors = [doctor]
        
        completionHandler(doctors, nil)
    }
    
    func getAvailableSlots(date: Date, doctor_id: Int, examinationType_id: Int, completionHandler: @escaping ([String]?, Error?) -> Void) {
        self.testFetchSlotDate = date
        self.testFetchSlotDoctorId = doctor_id
        self.testFetchSlotExaminationType_id = examinationType_id
        let slots = ["10:00", "10:15", "10:30"]
        
        completionHandler(slots, nil)
    }
    
    func addReservation(date: Date, starting_time: String, doctor_id: Int, examinationType: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        
        self.testAddReservationDate = date
        self.testAddReservationDoctorId = doctor_id
        self.testAddReservationStartingTime = starting_time
        self.testAddReservationExaminationType_id = examinationType
        completionHandler(true, nil)
    }
    
    func deleteReservation(reservation_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        self.testDeletionReservationId = reservation_id
    }
    
    func getAvailableDates(doctor_id: Int, completionHandler: @escaping ([Date]?, Error?) -> Void) {
        self.testGetAvailableDateDoctorId = doctor_id
        
        var dates: [Date] = []
        let dateFormatter = DateFormatter()
         
        dateFormatter.dateFormat = "YYYY-mm-dd"
        
        dates.append(dateFormatter.date(from: "2022-01-01")!)
        dates.append(dateFormatter.date(from: "2022-01-02")!)
        dates.append(dateFormatter.date(from: "2022-01-03")!)
        
        completionHandler(dates, nil)
        
    }
    
    
}
