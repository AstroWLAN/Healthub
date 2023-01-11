//
//  DBHelperProtocol.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/12/22.
//

import Foundation
import CoreData

public protocol DBHelperProtocol {
    
    func create(_ object: NSManagedObject)
    func fetchFirst(_ objectType: NSManagedObject.Type, predicate: NSPredicate?) -> Result<NSManagedObject?, Error>
    func fetch(_ objectType: NSManagedObject.Type, predicate: NSPredicate?, limit: Int?) -> Result<[NSManagedObject], Error>
    func update(_ object: NSManagedObject)
    func delete(_ object: NSManagedObject)
    func deleteAllEntries(entity: String)
    func getContext() -> NSManagedObjectContext
}

/*public extension DBHelperProtocol {
    func fetch(_ objectType: NSManagedObject.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[NSManagedObject], Error> {
        return fetch(objectType, predicate: predicate, limit: limit)
    }
}*/
