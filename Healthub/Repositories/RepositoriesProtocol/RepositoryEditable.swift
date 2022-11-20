//
//  RepositoryEditable.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

protocol RepositoryEditable{
    associatedtype T
    
    func edit(_ item: T, completionHandler: @escaping (Error?) -> Void)
}
