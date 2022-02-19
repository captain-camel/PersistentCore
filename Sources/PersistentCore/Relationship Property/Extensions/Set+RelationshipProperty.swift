//
//  Set+RelationshipProperty.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Set: RelationshipType where Element: PersistentObject {
    typealias Destination = Element
    
    typealias RawType = NSSet
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toMany }
    
    static var ordered: Bool { false }
    
    init(relationshipPrimitive: RawType) {
        self = Set(relationshipPrimitive.map { Destination(object: ($0 as! NSManagedObject)) })
    }
    
    var relationshipPrimitive: RawType {
        NSSet(array: map { $0.managedObject! })
    }
}
