//
//  RelationshipProperty.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

protocol RelationshipType {
    associatedtype Destination: PersistentObject
    
    associatedtype RawType
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { get }
    
    static var ordered: Bool { get }
    
    init(relationshipPrimitive: RawType)
    
    var relationshipPrimitive: RawType { get }
}
