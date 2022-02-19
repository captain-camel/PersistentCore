//
//  Fetch+or.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Fetch {
    func or<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, equals value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey
        let predicate: NSPredicate

        switch value.storablePrimitive {
        case nil as Any?:
            predicate = NSPredicate(format: "\(key) == nil")
        default:
            predicate = NSPredicate(format: "\(key) == %@", argumentArray: [value.storablePrimitive])
        }

        addPredicate(predicate, combinationType: .and)
        return self
    }
    
    func or<Property>(_ keyPath: KeyPath<Object, PersistentObject.Relationship<Property>>, equals value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) == %@", argumentArray: [value.relationshipPrimitive]), combinationType: .and)
        return self
    }
    
    func or(_ isIncluded: @escaping (Object) -> Bool) -> Fetch {
        addPredicate(NSPredicate { object, _ in
            return isIncluded(object as! Object)
        }, combinationType: .and)
        return self
    }
    
    func or<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, greaterThan value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) > %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
    func or<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, lessThan value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) < %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
    func or<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, greaterThanOrEqualTo value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) >= %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
    func or<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, lessThanOrEqualTo value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) <= %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
}
