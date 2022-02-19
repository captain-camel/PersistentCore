//
//  Optional+RelationshipProperty.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Optional: RelationshipType where Wrapped: PersistentObject {
    typealias Destination = Wrapped

    typealias RawType = NSManagedObject?
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toOne }
    
    static var ordered: Bool { false }
    
    init(relationshipPrimitive: RawType) {
        self = relationshipPrimitive.map { Destination(object: $0) }
    }
    
    var relationshipPrimitive: RawType {
        self?.managedObject
    }
}
