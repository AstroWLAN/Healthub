//
//  TicketViewModel.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 01/12/22.
//

import Foundation
class TicketViewModel : ObservableObject{
    
    private let reservationsRepository: any ReservationRepositoryProtocol
    @Published private(set) var reservations: [Reservation] = []
    @Published private(set) var doctors: [Doctor] = []
    @Published private(set) var slots: [String] = []
    
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
}
