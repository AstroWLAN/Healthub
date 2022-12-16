//
//  TicketViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
import SwiftUI
import Combine
class TicketViewModel : ObservableObject{
    
    private let reservationsRepository: any ReservationRepositoryProtocol
    @Published private(set) var reservations: [Reservation] = []
    @Published private(set) var doctors: [Doctor] = []
    @Published private(set) var availabilities: [Date] = []
    @Published private(set) var slots: [String] = []
    private let cache = NSCache<NSString, NSArray>()
    
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    
    @Published var completed: Bool = false{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var isLoadingTickets = false{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var hasError: Bool = false{
        willSet {
            objectWillChange.send()
        }
    }
    @Published var sent: Bool = false
    {
        willSet {
            objectWillChange.send()
        }
    }
    
    
    init(reservationsRepository: any ReservationRepositoryProtocol) {
        self.reservationsRepository = reservationsRepository
    }
    
    func fetchTickets(force_reload: Bool = false){
        if force_reload == true{
            self.isLoadingTickets = true
            reservationsRepository.getAll(){(reservations, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                
                if let reservations = reservations{
                    
                    self.reservations = reservations
                    self.isLoadingTickets = false
                }
                
            }
        }else{
            if let cachedVersion = cache.object(forKey: "tickets" as NSString) as? [Reservation] {
                // use the cached version
                self.reservations = cachedVersion
                self.isLoadingTickets = false
            } else {
                self.isLoadingTickets = true
                reservationsRepository.getAll(){(reservations, error) in
                    if let error = error{
                        print(error.localizedDescription)
                    }
                    
                    if let reservations = reservations{
                        
                        self.reservations = reservations
                        self.isLoadingTickets = false
                        self.cache.setObject(reservations as NSArray, forKey: "tickets")
                    }
                    
                }
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
            self.completed = false
            
            reservationsRepository.addReservation(date: date, starting_time: starting_time, doctor_id: doctor_id, examinationType: examinationType_id){(success, error) in
                if let error = error{
                    print(error.localizedDescription)
                    self.hasError = true
                    self.sent = false
                }
                if let reservationCompleted = success{
                    if reservationCompleted == true{
                        self.completed = true
                        self.sent = false
                        self.fetchTickets(force_reload: true)
                    }else{
                        self.hasError = true
                        self.sent = false
                    }
                }
            }
            self.sent = true
        }
        
        
        func deleteReservation(reservation_id: Int){
            reservationsRepository.delete(reservation_id: reservation_id){(success, error) in
                if let error = error{
                    print(error.localizedDescription)
                }
                
                self.reservations.removeAll(where: {$0.id == reservation_id})
                self.fetchTickets(force_reload: true)
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

