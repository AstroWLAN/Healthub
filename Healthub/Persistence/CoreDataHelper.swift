//
//  CoreDataHelper.swift
//  Healthub
//
//  Created by Giovanni Dispoto on 29/12/22.
//

import Foundation
import CoreData

class CoreDataHelper: DBHelperProtocol{
    
    static let context = CoreDataHelper().getContext()
    
    init(){}
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func create(_ object: NSManagedObject) {
        
        do{
            getContext().insert(object)
            try getContext().save()
        } catch {
            fatalError("error saving a context while creating an object")
        }
        
    }
    
    func fetch(_ objectType: NSManagedObject.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[NSManagedObject], Error>{
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "\(objectType)")//objectType.fetchRequest()
        request.predicate = predicate
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            let result = try getContext().fetch(request)
            return .success(result as? [NSManagedObject] ?? [])
        }catch{
            return .failure(error)
        }
        
    }
    
    func fetchFirst(_ objectType: NSManagedObject.Type, predicate: NSPredicate?) -> Result<NSManagedObject?, Error> {
        
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try getContext().fetch(request) as? [NSManagedObject]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ object: NSManagedObject) {
        do{
            try getContext().save()
        } catch {
            fatalError("error saving a context while creating an object")
        }
    }
    
    func delete(_ object: NSManagedObject) {
        
        do{
            getContext().delete(object)
            try getContext().save()
        } catch {
            fatalError("error saving a context while creating an object")
        }
    }
    
    
    func deleteAllEntries(entity: String){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try getContext().execute(deleteRequest)
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
