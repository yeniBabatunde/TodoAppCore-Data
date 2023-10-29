//
//  Model.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit
import CoreData

enum FetchResult<T> {
    case success([T])
    case failure (Error)
}

enum CachingManager {
    static let dataModel = "DataModel"
}

class CoreDataStack: NSObject {
    
   lazy var persistentContainer: NSPersistentContainer = {

       let container = NSPersistentContainer(name: CachingManager.dataModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func addObject<T: NSManagedObject>(entityType: T.Type) -> T {
        let newObject = entityType.init(context: context)
        return newObject
    }
    
    func create<T: NSManagedObject>(type: T.Type) -> T? {
        var newObject: T?
        if let entity = NSEntityDescription.entity(forEntityName: T.description(), in: context) {
            newObject = T(entity: entity, insertInto: context)
        }
        return newObject
    }
    
    func saveObject() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchObjects<T: NSManagedObject>(entityName: T.Type, predicate: NSPredicate?, completion: @escaping (FetchResult<T>) -> Void) {
        let entityName = String(describing: entityName)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do {
            let objects = try context.fetch(fetchRequest)
            completion(.success(objects))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteObject<T: NSManagedObject>(_ object: T) {
        context.delete(object)
    }
    
    func deleteAllObjects<T: NSManagedObject>(entityName: T.Type, predicate: NSPredicate?) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entityName = String(describing: entityName)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        let batchDeletedRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeletedRequest)
        } catch {
            print("Error removing all Items \(error)")
        }
    }
}
