//
//  File.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Array: RelationshipType where Element: PersistentObject {
    typealias Destination = Element
    
    typealias RawType = NSArray
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toMany }
    
    static var ordered: Bool { true }
    
    init(relationshipPrimitive: RawType) {
        self = relationshipPrimitive.map { Destination(object: ($0 as! NSManagedObject)) }
    }

    var relationshipPrimitive: RawType {
        NSArray(array: self)
    }
}
