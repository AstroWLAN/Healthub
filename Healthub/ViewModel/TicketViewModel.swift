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
}
