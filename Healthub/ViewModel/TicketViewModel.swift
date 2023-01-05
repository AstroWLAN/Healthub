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
    private(set) var connectivityProvider: ConnectionProvider
    @Published private(set) var reservations: [Reservation] = []{
        willSet {
            objectWillChange.send()
        }
    }
    @Published private(set) var doctors: [Doctor] = []
    @Published private(set) var availabilities: [Date] = []
    @Published private(set) var slots: [String] = []
    
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
    
    
    init(reservationsRepository: any ReservationRepositoryProtocol, connectivityProvider: ConnectionProvider) {
        self.reservationsRepository = reservationsRepository
        self.connectivityProvider = connectivityProvider
        self.connectivityProvider.connect()
    }
    
    func fetchTickets(force_reload: Bool = false){
        self.isLoadingTickets = true
        reservationsRepository.getAll(force_reload:force_reload){(reservations, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            
            if let reservations = reservations{
                
                self.reservations = reservations
                self.connectivityProvider.connect()
                self.connectivityProvider.sendWatchMessage(reservations)
                self.isLoadingTickets = false
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
                    if reservationCompleted == true {
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
            print(self.reservations)
            print(self.reservations.count)
            self.reservations = self.reservations.filter{$0.id != reservation_id}
            reservationsRepository.deleteReservation(reservation_id: reservation_id){(success, error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    print(self.reservations)
                    print(self.reservations.count)
                }
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

