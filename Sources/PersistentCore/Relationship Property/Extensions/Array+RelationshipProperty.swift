//
//  File.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Array: RelationshipProperty where Element: PersistentObject {
    typealias Destination = Element
    
    typealias RawType = NSArray
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { .toMany }
    
    static var ordered: Bool { true }
    
    init(nativeValue: RawType) {
        self = nativeValue.map { Destination(object: ($0 as! NSManagedObject)) }
    }

    var rawValue: RawType {
        NSArray(array: self)
    }
}
