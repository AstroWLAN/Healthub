//
//  Pathology.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 18/11/22.
//

import Foundation

struct Pathology{
    
    private(set) var id: Int
    private(set) var name:String
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
}
