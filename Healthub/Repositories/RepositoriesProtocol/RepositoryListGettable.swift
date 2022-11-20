//
//  RepositoryListGettable.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 20/11/22.
//

protocol RepositoryListGettable {
    associatedtype T
    func getAll(completionHandler: @escaping ([T]?, Error?) -> Void)
}
