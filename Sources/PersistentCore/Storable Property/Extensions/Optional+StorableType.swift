//
//  Optional+StorableType.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

extension Optional: StorableType where Wrapped: StorableType {
    public typealias PrimitiveType = Wrapped.PrimitiveType?
    
    public init(storablePrimitive: PrimitiveType) {
        if let primitive = storablePrimitive {
            self = Wrapped(storablePrimitive: primitive)
        } else {
            self = nil
        }
    }
    
    public var storablePrimitive: PrimitiveType {
        self?.storablePrimitive
    }
}
