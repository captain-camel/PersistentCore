//
//  PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

protocol PersistentPrimitive: StorableType {
    static var attributeType: NSAttributeType { get }
    
    static var optional: Bool { get }
}

extension PersistentPrimitive {
    init(storablePrimitive: Self) {
        self = storablePrimitive
        print("using primative get\(String(describing: type(of: self)))")
    }
    
    var storablePrimitive: Self {
        print("using primative set")
        return self
        
    }
}
