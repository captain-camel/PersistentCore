//
//  Optional+StorableProperty.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

extension Optional: StorableType where Wrapped: StorableType {
    typealias PrimitiveType = Wrapped.PrimitiveType?
    
    init(storablePrimitive: PrimitiveType) {
        if let primitive = storablePrimitive {
            self = Wrapped(storablePrimitive: primitive)
        } else {
            self = nil
        }
    }
    
    var storablePrimitive: PrimitiveType {
        self?.storablePrimitive
    }
}
