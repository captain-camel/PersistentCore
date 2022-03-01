//
//  Optional+RelationshipType.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Optional: RelationshipType where Wrapped: PersistentObject {
    public typealias Destination = Wrapped

    public typealias RawType = NSManagedObject?
    
    public static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toOne }
    
    public static var ordered: Bool { false }
    
    public init(relationshipPrimitive: RawType, dataStack: DataStack) {
        self = relationshipPrimitive.map { Destination(object: $0, dataStack: dataStack) }
    }
    
    public var relationshipPrimitive: RawType {
        self?.managedObject
    }
}
