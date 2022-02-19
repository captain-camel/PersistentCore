//
//  Set+RelationshipProperty.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Set: RelationshipProperty where Element: PersistentObject {
    typealias Destination = Element
    
    typealias RawType = NSSet
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toMany }
    
    static var ordered: Bool { false }
    
    init(nativeValue: RawType) {
        self = Set(nativeValue.map { Destination(object: ($0 as! NSManagedObject)) })
    }
    
    var rawValue: RawType {
        NSSet(array: map { $0.managedObject! })
    }
}
