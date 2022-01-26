//
//  PersistentObject.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

// TODO: Make PersistentObject conform to ObservableObject
public class PersistentObject {
    var managedObject: NSManagedObject!

    required init(object: NSManagedObject?) {
        self.managedObject = object
        
        setKeys()
    }
    
    convenience init(dataStack: DataStack = .default) {
        self.init(
            object: NSManagedObject(
                entity: Self.entities[String(describing: Self.self)]!,
                insertInto: DataStack.default.container.viewContext
            )
        )
    }
    
    static var meta: Self {
        self.init(object: nil)
    }
    
    // TODO: Fix inits
    private func setKeys() {
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let property = child.value as? PersistentProperty {
                property.key = String(child.label!.dropFirst())
            }
        }
    }
    
    static var entities: [String: NSEntityDescription] = [:]
    
    class func prepareEntityDescription() {
        let key = String(describing: self)
        
        let entityDescription = NSEntityDescription()
        
        entityDescription.name = key
        entityDescription.managedObjectClassName = "NSManagedObject"//key
        
        entities[key] = entityDescription
    }
    
    class func createEntityDescription() -> NSEntityDescription {
        let key = String(describing: self)
        
        guard let entityDescription = entities[key] else {
            fatalError("Failed to find entity description for `\(key)`. This likely means that `prepareEntityDescription()` wasn't called before `createEntityDescription()`.")
        }
        
        entityDescription.properties = Mirror(reflecting: self.meta).children.compactMap { child in
            if let property = child.value as? PersistentProperty {
                return property.propertyDescription
            }
            
            return nil
        }
        
        return entityDescription
    }
}
