//
//  Optional+RelationshipProperty.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Optional: RelationshipProperty where Wrapped: PersistentObject {
    typealias Destination = Wrapped

    typealias RawType = NSManagedObject?
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toOne }
    
    static var ordered: Bool { false }
    
    init(nativeValue: RawType) {
        self = nativeValue.map { Destination(object: $0) }
    }
    
    var rawValue: RawType {
        self?.managedObject
    }
}
