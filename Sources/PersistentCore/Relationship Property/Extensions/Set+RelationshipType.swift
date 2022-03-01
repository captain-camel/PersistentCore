//
//  Set+RelationshipType.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Set: RelationshipType where Element: PersistentObject {
    public typealias Destination = Element
    
    public typealias RawType = NSSet
    
    public static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toMany }
    
    public static var ordered: Bool { false }
    
    public init(relationshipPrimitive: RawType, dataStack: DataStack) {
        self = Set(relationshipPrimitive.map { Destination(object: ($0 as! NSManagedObject), dataStack: dataStack) })
    }
    
    public var relationshipPrimitive: RawType {
        NSSet(array: map { $0.managedObject! })
    }
}
