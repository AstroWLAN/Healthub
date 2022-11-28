//
//  ClientProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 26/11/22.
//

import Foundation

protocol ClientProtocol{
    func fetch<Request, Response>(_ endpoint: API.Types.Endpoint,
                                  method: API.Types.Method,
                                  body: Request?,
                                  then callback:((Result<Response, API.Types.Error>) -> Void)?
    ) where Request: Encodable, Response: Decodable
    
    func get<Response>(_ endpoint: API.Types.Endpoint, then callback:((Result<Response, API.Types.Error>) -> Void)?
    ) where Response: Decodable
}
