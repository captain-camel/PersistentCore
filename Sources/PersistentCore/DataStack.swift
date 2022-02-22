//
//  DataStack.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

public class DataStack {
    init(entities: [PersistentObject.Type]) {
        self.entities = entities
        
        let model = NSManagedObjectModel()
        
        for entity in entities {
            entity.prepareEntityDescription()
        }
        
        model.entities = entities.map { $0.createEntityDescription() }
        
        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    let autosave = false
    
    var entities: [PersistentObject.Type] {
        didSet {
            for entity in entities {
                entity.prepareEntityDescription()
            }
            
            container.managedObjectModel.entities = entities.map { $0.createEntityDescription() }
        }
    }
    
    let container: NSPersistentContainer
    
    private static var defaultStored: DataStack?
    
    static var `default`: DataStack {
        get {
            defaultStored!
        }
        set {
            defaultStored = newValue
        }
    }
    
    public func save() {
        try! container.viewContext.save()
    }
}
