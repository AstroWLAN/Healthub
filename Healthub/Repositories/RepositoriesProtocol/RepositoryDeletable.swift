//
//  RepositoryDeletable.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

protocol RepositoryDeletable{
    associatedtype T
    
    func delete(_ item: T, completionHandler: @escaping (Bool?, Error?) -> Void)
}
