//
//  Repository.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//
protocol RepositoryAddable {
    associatedtype T
    
    func add(_ item: T, completionHandler: @escaping (Bool?, Error?) -> Void)
    
}
