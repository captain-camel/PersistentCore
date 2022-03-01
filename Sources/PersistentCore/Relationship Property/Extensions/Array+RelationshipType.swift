//
//  Array+RelationshipType.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Array: RelationshipType where Element: PersistentObject {
    public typealias Destination = Element
    
    public typealias RawType = NSArray
    
    public static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toMany }
    
    public static var ordered: Bool { true }
    
    public init(relationshipPrimitive: RawType, dataStack: DataStack) {
        self = relationshipPrimitive.map { Destination(object: ($0 as! NSManagedObject), dataStack: dataStack) }
    }

    public var relationshipPrimitive: RawType {
        NSArray(array: self)
    }
}
