//
//  CoreDataHelper.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/12/22.
//

import Foundation
import CoreData

class CoreDataHelper: DBHelperProtocol{
    
    typealias ObjectType = NSManagedObject
    
    typealias PredicateType = NSPredicate
    
    static let shared = CoreDataHelper()
    
    var context : NSManagedObjectContext {persistentContainer.viewContext}
    
    private init(){}
    
    func create(_ object: NSManagedObject) {
        
        do{
            try context.save()
        } catch {
            fatalError("error saving a context while creating an object")
        }
        
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error>{
        
        let request = NSFetchRequest<T>(entityName: "\(objectType)")//objectType.fetchRequest()
        request.predicate = predicate
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            let result = try context.fetch(request)
            return .success(result as? [T] ?? [])
        }catch{
            return .failure(error)
        }
        
    }
    
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ object: NSManagedObject) {
        do{
            try context.save()
        } catch {
            fatalError("error saving a context while creating an object")
        }
    }
    
    func delete(_ object: NSManagedObject) {
        
        do{
            context.delete(object)
            try context.save()
        } catch {
            fatalError("error saving a context while creating an object")
        }
    }
    
    
    func deleteAllEntries(entity: String){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch let error as NSError {
            fatalError("Unable to delete: \(error)")
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "persistenceData")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

    func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    
}
