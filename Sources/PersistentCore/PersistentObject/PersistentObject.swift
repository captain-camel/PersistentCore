//
//  PersistentObject.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData
import Combine

public class PersistentObject: ObservableObject {
    var managedObject: NSManagedObject!
    
    func silentlyUpdatingCopy() -> Self {
        let copy = Self(object: managedObject)
        copy.silent = true
        
        return copy
    }
    
    enum UpdatePolicy: ExpressibleByBooleanLiteral {
        case silent
        case withoutSaving
        case `true`

        init(booleanLiteral value: Bool) {
            if value {
                self = .true
            } else {
                self = .silent
            }
        }
    }
    
    private var silent = false
    
    var propertiesUpdatedSilently: [String] = []
    
    func updateSilentlyUpdatedProperties() {
        for key in propertiesUpdatedSilently {
            managedObject.didChangeValue(forKey: key)
        }
    }
    
    func getValue<T: PersistentPrimitive>(forKey key: String) -> T {
        managedObject.willAccessValue(forKey: key)
        
        defer {
            managedObject.didAccessValue(forKey: key)
        }
        
        return managedObject.value(forKey: key) as! T
    }
    
    func setValue<T: PersistentPrimitive>(_ value: T, forKey key: String) {
        if !silent {
            managedObject.willChangeValue(forKey: key)
        }
        
        switch value {
        case nil as Any?:
            managedObject.setNilValueForKey(key)
        default:
            managedObject.setPrimitiveValue(value, forKey: key)
        }
        
        if !silent {
            managedObject.didChangeValue(forKey: key)
            DataStack.default.save()
        } else {
            propertiesUpdatedSilently.append(key)
        }
    }
    
    internal required init(object: NSManagedObject?) {
        self.managedObject = object
        
        republisher = managedObject.objectWillChange.sink {
            self.objectWillChange.send()
        }
        
        setKeys()
    }
    
    private var republisher: AnyCancellable? = nil
    
    static func create() -> Self {
        self.init()
    }
    
    required convenience init(dataStack: DataStack = .default) {
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
        entityDescription.managedObjectClassName = String(describing: NSManagedObject.self)
        
        entities[key] = entityDescription
    }
    
    class func createEntityDescription() -> NSEntityDescription {
        let key = String(describing: self)
        
        guard let entityDescription = entities[key] else {
            fatalError("Failed to find entity description for `\(key)`. This likely means that `prepareEntityDescription()` wasn't called before `createEntityDescription()`.")
        }
        
        entityDescription.properties = Mirror(reflecting: meta).children.compactMap { child in
            if let property = child.value as? PersistentProperty {
                return property.propertyDescription
            }

            return nil
        }
        
        return entityDescription
    }
}
