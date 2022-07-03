//
//  PersistentObject.swift
//
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData
import Combine

open class PersistentObject: ObservableObject {
    var managedObject: NSManagedObject!
    public let dataStack: DataStack!
    
    func silentlyUpdatingCopy() -> Self {
        let copy = Self(object: managedObject, dataStack: dataStack)
        copy.silent = true
        
        return copy
    }
    
    private var silent = false
    
    private var propertiesUpdatedSilently: [String] = []
    
    func resetPropertiesUpdatingSilently() {
        propertiesUpdatedSilently.removeAll()
    }
    //keep list only dont set
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
        
        print("GETTING VALUE FOR KEY: \(key)")
        let value = managedObject.value(forKey: key)!
        print("TYPE IS: \(type(of: value))")
        return value as! T
        
        
//        return managedObject.value(forKey: key) as! T
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
            try! managedObject.managedObjectContext!.save()
        } else {
            propertiesUpdatedSilently.append(key)
        }
    }
    
    // TODO: Optional object init shouldn't be public. Should this init be public at all?
    public required init(object: NSManagedObject?, dataStack: DataStack?) {
        self.managedObject = object
        self.dataStack = dataStack
        
//        republisher = managedObject.objectWillChange.sink {
//            self.objectWillChange.send()
//        }
        
        setKeys()
    }
    
//    private var republisher: AnyCancellable? = nil
    
//    static func create() -> Self {
//        self.init()
//    }
    
    public convenience init(dataStack: DataStack = .default) {
        self.init(
            object: NSManagedObject(
                entity: Self.entities[String(describing: Self.self)]!,
                insertInto: dataStack.container.viewContext
            ),
            dataStack: dataStack
        )
    }
    
    static var meta: Self {
        self.init(object: nil, dataStack: nil)
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
    
    class func entityDescription(_ description: NSEntityDescription?, iteration: Int) -> (description: NSEntityDescription, complete: Bool) {
        let key = String(describing: self)
        
        switch iteration {
        case 0:
            let entityDescription = NSEntityDescription()
            
            entityDescription.name = key
            entityDescription.managedObjectClassName = String(describing: NSManagedObject.self)
            
            entities[key] = entityDescription
            
            return (description: entityDescription, complete: false)
            
        case 1...:
            var complete = true
            
            let mirror = Mirror(reflecting: meta)
            
            if iteration == 1 {
                description!.properties = mirror.children.map(\.value).compactMap { $0 as? PersistentProperty }.map { property in
                    let (description, propertyComplete) = property.propertyDescription(nil, iteration: 0)
                    
                    if !propertyComplete { complete = false }
                    
                    return description
                }
            } else {
                description!.properties = description!.properties.map { propertyDescription in
                    let (description, propertyComplete) = mirror.children.map(\.value).compactMap { $0 as? PersistentProperty }.first { $0.unwrappedKey == propertyDescription.name }!.propertyDescription(propertyDescription, iteration: iteration - 1)
                    
                    if !propertyComplete { complete = false }
                    
                    return description
                }
            }
            
            return (description: description!, complete: complete)
            
        default:
            guard let description = description else {
                fatalError("\(String(describing: Self.self)).\(#function) reached default case before returning non-nil entity description.")
            }

            return (description: description, complete: true)
        }
    }
}
