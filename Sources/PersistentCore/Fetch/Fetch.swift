//
//  Fetch.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

public struct Fetch<Object: PersistentObject> {
    var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: Object.self))
    
    private enum PredicateCombinationType {
        case and
        case or
    }
    
    private func addPredicate(_ predicate: NSPredicate, combinationType: PredicateCombinationType) {
        if let currentPredicate = fetchRequest.predicate {
            switch combinationType {
            case .and:
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPredicate, predicate])
            case .or:
                fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [currentPredicate, predicate])
            }
        } else {
            fetchRequest.predicate = predicate
        }
    }
    
    func `where`<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, equals value: Property) -> Fetch {
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
    
    func `where`<Property>(_ keyPath: KeyPath<Object, PersistentObject.Relationship<Property>>, equals value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) == %@", argumentArray: [value.relationshipPrimitive]), combinationType: .and)
        return self
    }
    
    func `where`(_ isIncluded: @escaping (Object) -> Bool) -> Fetch {
        addPredicate(NSPredicate { object, _ in
            
            return isIncluded(object as! Object)
        }, combinationType: .and)
        return self
    }
    
    func `where`<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, greaterThan value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) > %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
    func `where`<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, lessThan value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) < %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
    func `where`<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, greaterThanOrEqualTo value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) >= %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
    func `where`<Property>(_ keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, lessThanOrEqualTo value: Property) -> Fetch {
        let key = Object.meta[keyPath: keyPath].unwrappedKey

        addPredicate(NSPredicate(format: "\(key) <= %@", argumentArray: [value.storablePrimitive]), combinationType: .and)
        return self
    }
    
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
    
    func sorted<Property>(by keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, _ order: SortOrder = .ascending) -> Fetch {
        if fetchRequest.sortDescriptors == nil {
            fetchRequest.sortDescriptors = []
        }
        
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: keyPath, ascending: order == .ascending ? true : false))
        return self
    }
    
    func sorted<Property>(by keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, _ comparator: @escaping (Property, Property) -> ComparisonResult) {
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: keyPath, ascending: true, comparator: { first, second in
            switch comparator(first as! Property, second as! Property) {
            case .ascending:
                return .orderedAscending
            case .descending:
                return .orderedDescending
            case .equal:
                return .orderedSame
            }
        }))
    }
    
    enum ComparisonResult {
        case ascending
        case descending
        case equal
    }
    
    enum SortOrder {
        case ascending
        case descending
    }
}
