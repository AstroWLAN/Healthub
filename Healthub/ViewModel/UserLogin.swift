//
//  UserLogin.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 12/11/22.
//

import Foundation

struct UserLogin: Decodable{
    
    private(set) var access_token: String
    
    init(access_token: String){
        self.access_token = access_token
    }
    
}
