//
//  APITypes.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 19/11/22.
//

import Foundation

extension API {
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
            
        }
        
        enum Response{
            
            struct UserLogin: Decodable{
                var access_token: String
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
            case inter(reason: String)
            
            var errorDescription: String? {
                switch self {
                case .generic(let reason):
                    return reason
                case .inter(let reason) :
                    return "Internal Error: \(reason) "
                }
            }
            
        }
        
        enum Endpoint{
            case login(email:String, password: String)
            case getPathologies(token: String)
            case deletePathology(token: String, id: Int)
            case addPathology(token: String)
            
            var url: URL{
                var components = URLComponents()
                components.host = "localhost"
                components.scheme = "https"
                switch self{
                    
                case .login(let email, let password):
                    components.path="/auth"
                    components.queryItems = [
                        URLQueryItem(name: "email", value : email),
                        URLQueryItem(name: "password", value: password)
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
