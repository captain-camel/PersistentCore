//
//  StorableProperty.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

protocol StorableType {
    associatedtype PrimitiveType: PersistentPrimitive
    
    init(storablePrimitive: PrimitiveType)
    
    var storablePrimitive: PrimitiveType { get }
}
