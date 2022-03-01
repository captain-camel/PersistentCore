//
//  PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

public protocol PersistentPrimitive: StorableType {
    static var attributeType: NSAttributeType { get }
    
    static var optional: Bool { get }
}

extension PersistentPrimitive {
    public init(storablePrimitive: Self) {
        self = storablePrimitive
        print("using primative get\(String(describing: type(of: self)))")
    }
    
    public var storablePrimitive: Self {
        print("using primative set")
        return self
        
    }
}
