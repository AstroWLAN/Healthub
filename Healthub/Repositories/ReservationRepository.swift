//
//  ReservationsRepository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/11/22.
//

import Foundation
import SwiftKeychainWrapper
struct ReservationsRepository: ReservationRepositoryProtocol{
    
    private var client: any ClientProtocol
    
    init(client: any ClientProtocol) {
        self.client = client
    }
    
    func add(date: Date, doctor_id: Int, examinationType: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        let dateFormatter = DateFormatter()
         
        dateFormatter.dateFormat = "YYYY-mm-dd"
        
        let date_ = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let starting_time = dateFormatter.string(from: date)
        
        let body = API.Types.Request.AddReservation(date: date_, starting_time: starting_time, doctor_id: doctor_id, examination_type: examinationType)
        
       client
            .fetch(.addReservation(token: token!), method: .post, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK", nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
        
        
    }
    
    func delete(reservation_id: Int, completionHandler: @escaping (Bool?, Error?) -> Void) {
        //code
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        let body = API.Types.Request.Empty()
        client
            .fetch(.deleteReservation(token: token!, reservation_id: reservation_id), method: .delete, body: body){(result: Result<API.Types.Response.GenericResponse, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(success.status == "OK", nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
            }
                
            
        
    }
    
    func getAll(completionHandler: @escaping ([Reservation]?, Error?) -> Void) {
        let token : String? = KeychainWrapper.standard.string(forKey: "access_token")
        guard token != nil else {
            fatalError("Token not present")
        }
        
        client
            .get(.getReservations(token: token!)){ (result: Result<API.Types.Response.GetReservations, API.Types.Error>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let success):
                        completionHandler(self.processReservations(success), nil)
                    case .failure(let failure):
                        completionHandler(nil,failure)
                    }
                }
        }
    }
    
    private func processReservations(_ results: API.Types.Response.GetReservations) -> [Reservation]{
        var local = [Reservation]()
        
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd"
        
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        
        for result in results.reservations{
            let doctor = Doctor(id: result.doctor.id, name: result.doctor.name,address: result.doctor.address)
            let examinationType = ExaminationType(id: result.examinationType.id, name: result.examinationType.name, duration_in_minutes: result.examinationType.duration_in_minutes)
            
            let reservation = Reservation(id: result.id, date: date.date(from: "\(result.date)")!, time: time.date(from:"\(result.starting_time)")!, doctor: doctor, examinationType: examinationType)
            
            local.append(reservation)
        }
        
        return local
        
    }
    
   
    
    
}
