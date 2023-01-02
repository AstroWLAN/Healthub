//
//  APITypes.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 19/11/22.
//

import Foundation

extension API {
    
    struct GenderTranslation{
        public static let gender = [0: "male", 1:"female", 2: "other"]
        public static let gender_r = ["male": 0, "female": 1, "other": 2]
    }
    
    enum Types {
        
        enum Request {
            
            struct UserLogin: Encodable{
                var email: String
                var password: String
            }
            
            struct Empty: Encodable {}
            
            struct PathologyDelete : Encodable{
                var id: Int
            }
            
            struct AddPathology : Encodable {
                var name: String
            }
            
            
            struct UpdatePatient: Encodable{
                var name: String
                var sex: Int
                var dateOfBirth: String
                var fiscalCode: String
                var height: Int
                var weight: Float
                var phone: String
                
            }
            
            struct AddReservation: Encodable{
                var date: String
                var starting_time: String
                var doctor_id: Int
                var examination_type: Int
            }
            
            struct CreatePatient: Encodable{
                var email: String
                var password: String
                var name: String
                var sex: Int
                var dateOfBirth: String
                var fiscalCode: String
                var height: Int
                var weight: Float
                var phone: String
                
            }
            
            struct CreateTherapy: Encodable{
                var drug_ids: [Int16]
                var duration: String
                var name: String
                var comment: String
            }
            
            
        }
        
        enum Response{
            
            struct UserLogin: Decodable{
                var access_token: String
            }
            
            struct GetPatient: Decodable{
                var email: String
                var name: String
                var sex: Int
                var dateOfBirth: String
                var fiscalCode: String
                var height: Int
                var weight: Float
                var phone: String
                var pathologies: [String]
                
            }
            
            struct GetReservations:Decodable {
                
                var reservations: [ReservationElement]
                
                struct ReservationElement: Decodable{
                    var id: Int
                    var date: String
                    var starting_time: String
                    var doctor: DoctorElement
                    var examinationType: ExaminationTypeElement
                }
                
                struct DoctorElement: Decodable{
                    var id: Int
                    var name: String
                    var address: String
                }
                
                struct ExaminationTypeElement:Decodable{
                    var id: Int
                    var name: String
                    var duration_in_minutes: Int
                }
                
                
            }
            
            struct GetDoctorsByExamName: Decodable{
                var doctors: [DoctorElement]
                
                struct DoctorElement: Decodable{
                    var id: Int
                    var name: String
                    var address: String
                }
            }
            
            
            struct GetPathologies: Decodable {
                var pathologies : [PathologyElement]
                
                struct PathologyElement: Decodable {
                    var id: Int
                    var name: String
                }
            }
            
            struct GenericResponse: Decodable {
                var status : String
                var problem: String?
            }
            
            struct GetAvailableSlots: Decodable{
                var morning_slots : [String]
                var afternoon_slots: [String]
            }
            
            struct GetAvailableDates: Decodable{
                var availabilities: [DateElement]
                
                struct DateElement: Decodable{
                    var date: String
                }
            }
            
            struct GetTherapies: Decodable{
                var therapies: [TherapyElement]
                
                struct TherapyElement: Decodable{
                    var therapy_id: Int
                    var doctor: DoctorElement?
                    var drugs: [DrugElement]
                    var duration: String
                    var comment: String
                    var name: String
                    var interactions: [String]
                }
                
                struct DoctorElement: Decodable{
                    var id: Int
                    var name: String
                    var address: String
                }
                
                struct DrugElement:Decodable{
                    var id: Int
                    var group_description: String
                    var ma_holder: String
                    var equivalence_group_code: String
                    var denomination_and_packaging: String
                    var active_principle: String
                    var ma_code: String
                }
            }
            
            struct Search: Decodable{
                var medications: [DrugElement]
                
                struct DrugElement:Decodable{
                    var id: Int
                    var group_description: String
                    var ma_holder: String
                    var equivalence_group_code: String
                    var denomination_and_packaging: String
                    var active_principle: String
                    var ma_code: String
                }
                
            }
            
            
        }
        
        enum Error: LocalizedError {
            
            case generic(reason: String)
            case server(reason: String)
            case unauthorized(reason:String)
            case inter(reason:String)
            case loginError(reason: String)
            
            var errorDescription: String? {
                switch self {
                case .generic(let reason):
                    return reason
                case .inter(let reason) :
                    return "Internal Error: \(reason)"
                case .loginError(let reason):
                    return "Login Error: \(reason)"
                case .server(let reason):
                    return "Server Error: \(reason)"
                case .unauthorized(let reason):
                    return "Unautorized: \(reason)"
                }
            }
            
        }
        
        enum Endpoint{
            case login(email:String, password: String)
            case logout(token: String)
            case createPatient
            case getPathologies(token: String)
            case deletePathology(token: String, id: Int)
            case addPathology(token: String)
            case getPatient(token: String)
            case updatePatient(token: String)
            case getReservations(token: String)
            case deleteReservation(token: String, reservation_id: Int)
            case getDoctorsByExamName(token: String, exam_name: String)
            case getAvailableSlots(token: String, doctor_id: Int, examinationType: Int, date: String)
            case addReservation(token:String)
            case getAvailableDates(token: String, doctor_id: Int)
            case getDrugList(query: String)
            case getTherapies(token:String)
            case createTherapy(token: String)
            case deleteTherapy(token: String, therapy_id: Int)
            
            var url: URL{
                var components = URLComponents()
                components.host = "localhost"
                components.scheme = "http"
                switch self{
                    
                case .login(let email, let password):
                    components.path="/patients/auth"
                    components.queryItems = [
                        URLQueryItem(name: "email", value : email),
                        URLQueryItem(name: "password", value: password)
                    ]
                case .logout(let token):
                    components.path="/patients/logout"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .createPatient:
                    components.path="/patients"
                case .getPatient(let token):
                    components.path="/patients/me"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .updatePatient(let token):
                    components.path="/patients/me"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .getPathologies(let token):
                    components.path = "/patients/me/pathologies"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .deletePathology(let token, let id):
                    components.path = "/patients/me/pathologies"
                    components.path += "/\(String(id))"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .addPathology(let token):
                    components.path = "/patients/me/pathologies"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .getReservations(let token):
                    components.path = "/patients/reservations"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                    
                case .deleteReservation(let token, let reservation_id):
                    components.path = "/patients/reservations/\(String(reservation_id))"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token)
                    ]
                case .getDoctorsByExamName(let token, let exam_name):
                    components.path = "/patients/get_doctor_by_exam_name"
                    components.queryItems = [
                        URLQueryItem(name: "exam_name", value: exam_name),
                        URLQueryItem(name: "token", value : token)
                    ]
                    
                case .getAvailableSlots(let token, let doctor_id, let examinationType_id, let date):
                    components.path = "/reservations/\(doctor_id)/\(examinationType_id)/\(date)"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token),
                    ]
                    
                case .addReservation(let token):
                    components.path = "/patients/reservations"
                    components.queryItems = [
                        URLQueryItem(name: "token", value: token),
                        
                    ]
                case .getAvailableDates(let token, let doctor_id):
                    components.path = "/reservations/get_available_dates/\(doctor_id)"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token),
                    ]
                    
                case .getDrugList(let query):
                    components.path = "/therapies/search/\(query)"
                    
                    
                case .getTherapies(let token):
                    components.path = "/patients/me/therapies"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token),
                    ]
                    
                case .createTherapy(let token):
                    components.path = "/patients/me/therapies"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token),
                    ]
                    
                case .deleteTherapy(let token, let therapy_id):
                    components.path = "/patients/me/therapies/\(therapy_id)"
                    components.queryItems = [
                        URLQueryItem(name: "token", value : token),
                    ]
                }
                
                
                
                return components.url!
            }
            
        }
        
        enum Method: String{
            case get
            case post
            case put
            case delete
        }
        
       
    }
}
