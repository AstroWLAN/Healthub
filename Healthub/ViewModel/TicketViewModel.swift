//
//  TicketViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
import SwiftUI
class TicketViewModel : ObservableObject{
    
    private let reservationsRepository: any ReservationRepositoryProtocol
    @Published private(set) var reservations: [Reservation] = []
    @Published private(set) var doctors: [Doctor] = []
    @Published private(set) var availabilities: [Date] = []
    @Published private(set) var slots: [String] = []
    @Published var completed: Bool = false
    @Published var hasError: Bool = false
    
    
    init(reservationsRepository: any ReservationRepositoryProtocol) {
        self.reservationsRepository = reservationsRepository
    }
    
    func fetchTickets(){
        
        reservationsRepository.getAll(){(reservations, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let reservations = reservations{
                self.reservations = reservations
            }
            
        }
        
    }
    
    func fetchDoctorsByExamName(exam_name: String){
        
        reservationsRepository.getDoctorsByExamName(exam_name: exam_name){(doctors, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let doctors = doctors{
                self.doctors = doctors
            }
        }
    }
    
    func fetchSlots(doctor_id: Int, examinationType_id: Int, date: Date ){
        
        reservationsRepository.getAvailableSlots(date: date, doctor_id: doctor_id, examinationType_id: examinationType_id){(slots, error) in
            
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let slots = slots{
                self.slots = slots
            }
            
        }
        
    }
    
    func addReservation(date: Date, starting_time: String, doctor_id: Int, examinationType_id: Int){
        self.hasError = false
        reservationsRepository.addReservation(date: date, starting_time: starting_time, doctor_id: doctor_id, examinationType: examinationType_id){(success, error) in
            if let error = error{
                print(error.localizedDescription)
                self.hasError = true
            }
            if let reservationCompleted = success{
                if reservationCompleted == true{
                    self.completed = true
                }
            }
        }
    }
    
    func deleteReservation(reservation_id: Int){
        reservationsRepository.delete(reservation_id: reservation_id){(success, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            self.reservations.removeAll(where: {$0.id == reservation_id})
        }
    }
    
    func fetchAvailableDates(doctor_id: Int){
        reservationsRepository.getAvailableDates(doctor_id: doctor_id){(availabilities, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            self.availabilities = availabilities!
        }
    }
}
