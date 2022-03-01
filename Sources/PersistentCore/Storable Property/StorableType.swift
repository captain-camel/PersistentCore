//
//  StorableProperty.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

public protocol StorableType {
    associatedtype PrimitiveType: PersistentPrimitive
    
    init(storablePrimitive: PrimitiveType)
    
    var storablePrimitive: PrimitiveType { get }
}
