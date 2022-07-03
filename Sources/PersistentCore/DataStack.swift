//
//  DataStack.swift
//
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

public class DataStack {
    public init(entities: [PersistentObject.Type]) {
        self.entities = entities
        
        let model = NSManagedObjectModel()
        
        var entityDictionary: [String: NSEntityDescription] = [:]
        var allComplete: Bool
        var iteration = 0
        
        repeat {
            allComplete = true
            
            for entity in entities {
                let (description, complete) = entity.entityDescription(entityDictionary[String(describing: entity)], iteration: iteration)
                entityDictionary[String(describing: entity)] = description
                
                if !complete { allComplete = false }
            }
            
            iteration += 1
        } while !allComplete
        
        model.entities = Array(entityDictionary.values)
        
        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    let autosave = true
    
    let entities: [PersistentObject.Type]
    
    let container: NSPersistentContainer
    
    private static var defaultStored: DataStack?
    
    public static var `default`: DataStack {
        get {
            guard let defaultStored = defaultStored else {
                fatalError()
            }
            
            return defaultStored
        }
        set {
            defaultStored = newValue
        }
    }
    
    public func save() {
        try! container.viewContext.save()
    }
    
    public func fetch<Object: PersistentObject>(_ fetch: Fetch<Object>) -> [Object] {
        try! container.viewContext.fetch(fetch.fetchRequest).map { Object(object: $0, dataStack: self) }
    }
}
