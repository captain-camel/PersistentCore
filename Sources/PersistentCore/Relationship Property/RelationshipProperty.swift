//
//  RelationshipProperty.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

protocol RelationshipProperty {
    associatedtype Destination: PersistentObject
    
    associatedtype RawType
    
    static var relationshipKind: PersistentObject.Relationship<Self>.Kind { get }
    
    static var ordered: Bool { get }
    
    init(nativeValue: RawType)
    
    var rawValue: RawType { get }
}
