//
//  APIClient.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 19/11/22.
//

import Foundation

extension API {
    
    class Client{
        
        static let shared = Client()
        private let encoder = JSONEncoder()
        private let dateFormatter = DateFormatter()
        private let decoder = JSONDecoder()
        
        
        
        func fetch<Request, Response>(_ endpoint: Types.Endpoint,
                                      method: Types.Method = .get,
                                      body: Request? = nil,
                                      then callback:((Result<Response, Types.Error>) -> Void)? = nil
        ) where Request: Encodable, Response: Decodable{
            var urlRequest = URLRequest(url: endpoint.url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let body = body{
                do{
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    encoder.dateEncodingStrategy = .formatted(dateFormatter)
                    urlRequest.httpBody = try encoder.encode(body)
                }catch{
                    callback?(.failure(.inter(reason: "Could not encode body")))
                    return
                }
            }
            
            let dataTask = URLSession.shared
                .dataTask(with: urlRequest){ data, response, error in
                    
                    
                    if let error = error {
                        print("Fetch error: \(error)")
                        callback?(.failure(.generic(reason: "Could not fetch data: \(error.localizedDescription)")))
                    }else{
                        if let httpResponse = response as? HTTPURLResponse {
                            if httpResponse.statusCode == 401{
                                callback?(.failure(.unauthorized(reason: "\(httpResponse.statusCode)")))
                            }else{
                                if let data = data {
                                    do{
                                        self.dateFormatter.dateFormat = "yyyy-MM-dd"
                                        self.dateFormatter.calendar = Calendar(identifier: .iso8601)
                                        self.dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                        self.encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
                                        let result = try self.decoder.decode(Response.self, from: data)
                                        callback?(.success(result))
                                    }catch{
                                        print("Error: \(error)")
                                        callback?(.failure(.generic(reason: "Could not decode data: \(error.localizedDescription)")))
                                    }
                                }
                            }
                        }
                    }
                    
            }
            
            dataTask.resume()
        }
        
        
        func get<Response>(_ endpoint: Types.Endpoint,
                          then callback:((Result<Response, Types.Error>) -> Void)? = nil
        ) where Response: Decodable{
            let body: Types.Request.Empty? = nil
            
            fetch(endpoint, method:.get, body:body){ result in
                callback?(result)
            }
        }
        
        
    }
}
