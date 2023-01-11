//
//  MockClientReservations.swift
//  HealthubTests
//
//  Created by Giovanni Dispoto on 29/11/22.
//

import Foundation
@testable import Healthub

class MockClientReservations: Healthub.ClientProtocol{
    
    private (set) var numberGetReservations = 0
    private (set) var numberGetContacts = 0
    private (set) var numberAddReservations = 0
    private (set) var numberDeleteReservations = 0
    private (set) var numberAddContacts = 0
    private (set) var numberDeleteContacts = 0
    private (set) var numberGetDoctorList = 0
    private (set) var reservations: [Healthub.API.Types.Response.GetReservations.ReservationElement] = []
    private (set) var contacts : [Healthub.API.Types.Response.GetDoctorList.DoctorElement] = []
    private (set) var doctors : [Healthub.API.Types.Response.GetDoctorList.DoctorElement] = []
    func fetch<Request, Response>(_ endpoint: Healthub.API.Types.Endpoint, method: Healthub.API.Types.Method, body: Request?, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Request : Encodable, Response : Decodable {
        switch(endpoint){
            case .login(email: let email, password: let password):
                print("login")
            case .logout(token: let token):
                print("logout")
            case .getPathologies(token: let token):
                assertionFailure("Called getPathologies")
            case .deletePathology(token: let token, id: let id):
                assertionFailure("Called deletePathologies")
            case .addPathology(token: let token):
                assertionFailure("Called addPathologies")
            case .getPatient(token: let token):
                print("getPatient")
            case .updatePatient(token: let token):
                assertionFailure("Called updatePatient")
            case .getReservations(token: let token):
            var reservations : Healthub.API.Types.Response.GetReservations = Healthub.API.Types.Response.GetReservations(reservations: [])
                self.numberGetReservations = self.numberGetReservations + 1
            let r = Healthub.API.Types.Response.GetReservations.ReservationElement(id: 1, date: "2022-11-29", starting_time: "11:00", doctor: Healthub.API.Types.Response.GetReservations.DoctorElement(id: 1, name: "Gregory House", address: "221B Baker Street, Princeton", phone: "1234", email:"dr.house@mail.com"), examinationType: Healthub.API.Types.Response.GetReservations.ExaminationTypeElement(id: 1, name: "visit", duration_in_minutes: 15))
            reservations.reservations.append(r)
                
                callback?(.success(reservations as! Response))
        case .addReservation(token: let token):
            self.numberAddReservations = self.numberAddReservations + 1
            let reservation = body as! Healthub.API.Types.Request.AddReservation
            self.reservations.append(Healthub.API.Types.Response.GetReservations.ReservationElement(id: self.reservations.count + 1, date: reservation.date, starting_time: reservation.starting_time, doctor: Healthub.API.Types.Response.GetReservations.DoctorElement(id: reservation.doctor_id, name: "Gregory House", address: "221B Baker Street", phone: "1234", email:"dr.house@mail.com"), examinationType: Healthub.API.Types.Response.GetReservations.ExaminationTypeElement(id: reservation.examination_type, name: "exam", duration_in_minutes: 15)))
            
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
            
 
        case .deleteReservation(token: let token, reservation_id: let reservation_id):
            self.numberDeleteReservations = self.numberDeleteReservations + 1
            
            if(self.reservations.count == 0){
                callback?(.failure(Healthub.API.Types.Error.inter(reason: "No reservations")))
            }else{
                if let element = self.reservations.enumerated().first(where: {$0.element.id == reservation_id }){
                    self.reservations.remove(at: element.offset)
                    callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response))
                }else{
                    callback?(.failure(Healthub.API.Types.Error.inter(reason: "No element found")))
                }
                
            }
        case .getContacts(token: let token):
            self.numberGetContacts = self.numberGetContacts + 1
            var contacts_: Healthub.API.Types.Response.GetDoctorList = Healthub.API.Types.Response.GetDoctorList(doctors: [])
            let c = Healthub.API
                .Types.Response.GetDoctorList.DoctorElement(id: 1, name: "Gregory House", address: "221B Baker Street", phone: "1234", email:"dr.house@mail.com")
            contacts_.doctors.append(c)
            self.contacts = contacts_.doctors
            callback?(.success(contacts_ as! Response))
        case .addContact(token: let token, doctor_id: let doctor_id):
            self.numberAddContacts = self.numberAddContacts + 1
            
            self.contacts.append(Healthub.API.Types.Response.GetDoctorList.DoctorElement(id: doctor_id, name: "name", address: "addr", phone: "phone", email: "email"))
            
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
        
        case .deleteContact(token: let token, doctor_id: let doctor_id):
            self.numberDeleteContacts = self.numberDeleteContacts + 1
            
            if(self.contacts.count == 0){
                callback?(.failure(Healthub.API.Types.Error.inter(reason: "No reservations")))
            }else{
                if let element = self.contacts.enumerated().first(where: {$0.element.id == doctor_id }){
                    self.contacts.remove(at: element.offset)
                    callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response))
                }else{
                    callback?(.failure(Healthub.API.Types.Error.inter(reason: "No element found")))
                }
            }
        case .getAvailableDates(token: let token, doctor_id: let doctor_id):
            var availabilities_1: [Healthub.API.Types.Response.GetAvailableDates.DateElement] = []
            availabilities_1.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-01-01"))
            availabilities_1.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-01-02"))
            let dates_1: Healthub.API.Types.Response.GetAvailableDates = Healthub.API.Types.Response.GetAvailableDates(availabilities: availabilities_1)
            
            var availabilities_2: [Healthub.API.Types.Response.GetAvailableDates.DateElement] = []
            availabilities_2.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-02-01"))
            availabilities_2.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-03-02"))
            let dates_2: Healthub.API.Types.Response.GetAvailableDates = Healthub.API.Types.Response.GetAvailableDates(availabilities: availabilities_2)
            
            if(doctor_id == 1){
                callback?(.success( dates_1 as! Response ))
            }else if(doctor_id == 2){
                callback?(.success( dates_2 as! Response ))
            }
        
        case .getAvailableSlots(token: let token, doctor_id: let doctor_id, examinationType: let examination_type, date: let date):
            
            
            var morning_slots: [String] = []
            morning_slots.append("10:00")
            morning_slots.append("10:15")
            
            var afternoon_slots : [String] = []
            afternoon_slots.append("15:00")
            afternoon_slots.append("15:15")
            
            let slots: Healthub.API.Types.Response.GetAvailableSlots = Healthub.API.Types.Response.GetAvailableSlots(morning_slots: morning_slots , afternoon_slots: afternoon_slots)
            
            callback?(.success( slots as! Response ))
            
        case .getDoctorsByExamName(token: let token, exam_name: let exam_name):
            if exam_name == "vaccination"{
                var doctors:[Healthub.API.Types.Response.GetDoctorsByExamName.DoctorElement] = []
                doctors.append(Healthub.API.Types.Response.GetDoctorsByExamName.DoctorElement(id: 1, name: "A", address: "A", email: "A", phone: "A"))
                doctors.append(Healthub.API.Types.Response.GetDoctorsByExamName.DoctorElement(id: 2, name: "B", address: "B", email: "B", phone: "B"))
                let response = Healthub.API.Types.Response.GetDoctorsByExamName(doctors: doctors )
                callback?(.success( response as! Response ))
            }else{
                let response = Healthub.API.Types.Response.GetDoctorsByExamName(doctors: [] )
                callback?(.success( response as! Response ))
            }
        default:
            print("else")
        }
    }
    
    func get<Response>(_ endpoint: Healthub.API.Types.Endpoint, then callback: ((Result<Response, Healthub.API.Types.Error>) -> Void)?) where Response : Decodable {
        switch(endpoint){
            case .login(email: let email, password: let password):
                print("login")
            case .logout(token: let token):
                print("logout")
            case .getPathologies(token: let token):
                assertionFailure("Called getPathologies")
            case .deletePathology(token: let token, id: let id):
                assertionFailure("Called deletePathologies")
            case .addPathology(token: let token):
                assertionFailure("Called addPathologies")
            case .getPatient(token: let token):
                print("getPatient")
            case .updatePatient(token: let token):
                assertionFailure("Called updatePatient")
            case .getReservations(token: let token):
            var reservations : Healthub.API.Types.Response.GetReservations = Healthub.API.Types.Response.GetReservations(reservations: [])
                self.numberGetReservations = self.numberGetReservations + 1
            let r = Healthub.API.Types.Response.GetReservations.ReservationElement(id: 1, date: "2022-11-29", starting_time: "11:00", doctor: Healthub.API.Types.Response.GetReservations.DoctorElement(id: 1, name: "Gregory House", address: "221B Baker Street, Princeton", phone: "1234", email:"dr.house@mail.com"), examinationType: Healthub.API.Types.Response.GetReservations.ExaminationTypeElement(id: 1, name: "visit", duration_in_minutes: 15))
            reservations.reservations.append(r)
                
                callback?(.success(reservations as! Response))
        case .addReservation(token: let token):
            print("addReservation")
        case .deleteReservation(token: let token, reservation_id: let reservation_id):
            callback?(.success(Healthub.API.Types.Response.GenericResponse(status: "OK") as! Response))
        case .getContacts(token: let token):
            self.numberGetContacts = self.numberGetContacts + 1
            var contacts_: Healthub.API.Types.Response.GetDoctorList = Healthub.API.Types.Response.GetDoctorList(doctors: [])
            let c = Healthub.API
                .Types.Response.GetDoctorList.DoctorElement(id: 1, name: "Gregory House", address: "221B Baker Street", phone: "1234", email:"dr.house@mail.com")
            contacts_.doctors.append(c)
            self.contacts = contacts_.doctors
            callback?(.success(contacts_ as! Response))
        case .deleteContact(token: let token, doctor_id: let doctor_id):
            self.numberDeleteContacts = self.numberDeleteContacts + 1
            
            if(self.contacts.count == 0){
                callback?(.failure(Healthub.API.Types.Error.inter(reason: "No reservations")))
            }else{
                if let element = self.contacts.enumerated().first(where: {$0.element.id == doctor_id }){
                    self.contacts.remove(at: element.offset)
                    callback?(.success(API.Types.Response.GenericResponse(status: "OK") as! Response))
                }else{
                    callback?(.failure(Healthub.API.Types.Error.inter(reason: "No element found")))
                }
            }
        case .getDoctorList(token: let token):
            self.numberGetDoctorList = self.numberGetDoctorList + 1
            var doctors = Healthub.API.Types.Response.GetDoctorList(doctors: [])
            let c = Healthub.API
                .Types.Response.GetDoctorList.DoctorElement(id: 1, name: "Gregory House", address: "221B Baker Street", phone: "1234", email:"dr.house@mail.com")
            doctors.doctors.append(c)
            
            self.doctors = doctors.doctors
            callback?(.success(doctors as! Response))
        case .getAvailableDates(token: let token, doctor_id: let doctor_id):
            var availabilities_1: [Healthub.API.Types.Response.GetAvailableDates.DateElement] = []
            availabilities_1.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-01-01"))
            availabilities_1.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-01-02"))
            let dates_1: Healthub.API.Types.Response.GetAvailableDates = Healthub.API.Types.Response.GetAvailableDates(availabilities: availabilities_1)
            
            var availabilities_2: [Healthub.API.Types.Response.GetAvailableDates.DateElement] = []
            availabilities_2.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-02-01"))
            availabilities_2.append(Healthub.API.Types.Response.GetAvailableDates.DateElement(date: "2022-03-02"))
            let dates_2: Healthub.API.Types.Response.GetAvailableDates = Healthub.API.Types.Response.GetAvailableDates(availabilities: availabilities_2)
            
            if(doctor_id == 1){
                callback?(.success( dates_1 as! Response ))
            }else if(doctor_id == 2){
                callback?(.success( dates_2 as! Response ))
            }
        case .getAvailableSlots(token: let token, doctor_id: let doctor_id, examinationType: let examination_type, date: let date):
            
            
            var morning_slots: [String] = []
            morning_slots.append("10:00")
            morning_slots.append("10:15")
            
            var afternoon_slots : [String] = []
            afternoon_slots.append("15:00")
            afternoon_slots.append("15:15")
            
            let slots: Healthub.API.Types.Response.GetAvailableSlots = Healthub.API.Types.Response.GetAvailableSlots(morning_slots: morning_slots , afternoon_slots: afternoon_slots)
            
            callback?(.success( slots as! Response ))
        case .getDoctorsByExamName(token: let token, exam_name: let exam_name):
            if exam_name == "vaccination"{
                var doctors:[Healthub.API.Types.Response.GetDoctorsByExamName.DoctorElement] = []
                doctors.append(Healthub.API.Types.Response.GetDoctorsByExamName.DoctorElement(id: 1, name: "A", address: "A", email: "A", phone: "A"))
                doctors.append(Healthub.API.Types.Response.GetDoctorsByExamName.DoctorElement(id: 2, name: "B", address: "B", email: "B", phone: "B"))
                let response = Healthub.API.Types.Response.GetDoctorsByExamName(doctors: doctors )
                callback?(.success( response as! Response ))
            }else{
                let response = Healthub.API.Types.Response.GetDoctorsByExamName(doctors: [] )
                callback?(.success( response as! Response ))
            }
        default:
            print("else")
        }
    }
    
    
}
