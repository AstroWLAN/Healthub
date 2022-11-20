//
//  RepositorySingleGettable.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

protocol RepositorySingleGettable{
    associatedtype T
        
    func get(id: Int, completionHandler: @escaping (T?, Error?) -> Void)
}

