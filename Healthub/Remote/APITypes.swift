//
//  APITypes.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 19/11/22.
//

import Foundation

extension API {
    
    struct GenderTranslation{
        public static let gender = [0: "Male", 1:"Female", 2: "Other"]
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
            
            
            struct GetPathologies: Decodable {
                var pathologies : [PathologyElement]
                
                struct PathologyElement: Decodable {
                    var id: Int
                    var name: String
                }
            }
            
            struct GenericResponse: Decodable {
                var status : String
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
                    return "Internal Error: \(reason) "
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
            case getPathologies(token: String)
            case deletePathology(token: String, id: Int)
            case addPathology(token: String)
            case getPatient(token: String)
            case updatePatient(token: String)
            
            
            var url: URL{
                var components = URLComponents()
                components.host = "localhost"
                components.scheme = "https"
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
