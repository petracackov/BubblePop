//
//  DatabaseEntity.swift
//  BubblePop
//
//  Created by Petra Čačkov on 28/12/2020.
//

import UIKit

class DatabaseEntity {

    var id: UUID? = UUID()
    
    private static var entityName: String {
        let name = (String(describing: self) + "Entity")
        if name == "DatabaseEntity" { return "BaseEntity" }
        else { return name }
    }

    private var entityName: String {
        return type(of: self).entityName
    }
    
    private(set) var entity: BaseEntity?
    
    /// must be called from context thread
    required convenience init(entity: BaseEntity) {
        self.init()
        self.entity = entity
        self.c_fetchDataFromEntity()
    }
    
    func injectEntity(entity: BaseEntity) {
        self.entity = entity
    }
    
    /// must be called from context thread
    func c_fetchDataFromEntity() {
        if let entity = entity {
            self.id = entity.id
        }
    }
    
    /// must be called from context thread
    func c_writeDataToEntity() {
        if entity == nil {
            entity = DatabaseManager.shared.c_newEntity(withName: entityName) as? BaseEntity
        }
        if let entity = entity {
            entity.id = id
        }
    }
    
    /// must be called from context thread
    private func c_deleteFromDatabase() {
        if let entity = self.entity {
            DatabaseManager.shared.c_deleteFromDatabase(entity: entity)
        }
    }
    
    func deleteFromDatabase(completion: @escaping () -> Void) {
        DatabaseManager.shared.executeOnContextThreadAndReturnOnMain {
            self.c_deleteFromDatabase()
        } main: {
            completion()
        }
    }
    
    /// must be called from context thread
    private func c_saveToDatabase() {
        c_writeDataToEntity()
        DatabaseManager.shared.c_saveDatabase()
    }
    
    func saveToDatabase(completion: @escaping () -> Void) {
        DatabaseManager.shared.executeOnContextThreadAndReturnOnMain {
            self.c_saveToDatabase()
        } main: {
            completion()
        }

    }
    
    /// Fetches all objects and returns on main thread
    static func fetchAllObjects(completion: @escaping (_ objects: [DatabaseEntity]?, _ error: Error?) -> Void) {
        DatabaseManager.shared.executeOnContextThread {
            do {
                let objects = try (DatabaseManager.shared.c_fetchRequestObjects(withEntityName: entityName) as? [BaseEntity])?.map { self.init(entity: $0) }
                DispatchQueue.main.async {
                    completion(objects, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
