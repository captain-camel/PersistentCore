//
//  Int+StorableType.swift
//
//
//  Created by Cameron Delong on 2/22/22.
//

extension Int: StorableType {
    public typealias PrimitiveType = Int64
    
    public init(storablePrimitive: PrimitiveType) {
        self = Int(storablePrimitive)
    }
    
    public var storablePrimitive: PrimitiveType {
        Int64(self)
    }
}
