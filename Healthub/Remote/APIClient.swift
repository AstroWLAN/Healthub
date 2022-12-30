//
//  APIClient.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 19/11/22.
//

import Foundation

extension API {
    
    class Client: ClientProtocol{
        
        
        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()
        
        
        
        func fetch<Request, Response>(_ endpoint: API.Types.Endpoint,
                                      method: API.Types.Method = .get,
                                      body: Request? = nil,
                                      then callback:((Result<Response, API.Types.Error>) -> Void)? = nil
        ) where Request: Encodable, Response: Decodable{
            var urlRequest = URLRequest(url: endpoint.url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let body = body{
                do{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
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
                                UserDefaults.standard.set(false, forKey: "isLogged")
                            }else{
                                if let data = data {
                                    do{
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
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
        
        
        func get<Response>(_ endpoint: API.Types.Endpoint,
                           then callback:((Result<Response, API.Types.Error>) -> Void)? = nil
        ) where Response: Decodable{
            let body: Types.Request.Empty? = nil
            
            fetch(endpoint, method:.get, body:body){ result in
                callback?(result)
            }
        }
        
        
    }
}
