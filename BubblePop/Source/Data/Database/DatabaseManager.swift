//
//  DatabaseManager.swift
//  BubblePop
//
//  Created by Petra Čačkov on 28/12/2020.
//

import UIKit
import CoreData


class DatabaseManager {

    static let shared = DatabaseManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        }
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = { persistentContainer.newBackgroundContext() }()
    
    /// must be called from context thread
    func c_fetchRequestObjects(withEntityName: String) throws -> [AnyObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName)
        do {
            return try context.fetch(request) as [AnyObject]
        } catch {
            return nil
        }
    }
    
    /// must be called from context thread
    func c_newEntity(withName entityName: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
    
    /// must be called from context thread
    func c_saveDatabase() {
        do {
            try context.save()
        } catch {
            print("Failed saving entity")
        }
        
    }
    
    /// must be called from context thread
    func c_deleteFromDatabase(entity: BaseEntity) {
        do {
            context.delete(entity)
            try context.save()
        } catch {
            print("Failed deleting entity")
        }
    }
    
    func executeOnContextThread(block: @escaping () -> Void) {
        context.performAndWait {
            block()
        }
    }
    
    func executeOnContextThreadAndReturnOnMain(block: @escaping () -> Void, main: @escaping () -> Void) {
        context.performAndWait {
            block()
            DispatchQueue.main.async {
                main()
            }
        }
    }
    
}
