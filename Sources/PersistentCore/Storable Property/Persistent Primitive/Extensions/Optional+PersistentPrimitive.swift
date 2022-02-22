//
//  Optional+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

// TODO: Make sure optional primitives use this instead of `PersistentStorable`
extension Optional: PersistentPrimitive where Wrapped: PersistentPrimitive {
    static var attributeType: NSAttributeType { Wrapped.attributeType }
    
    static var optional: Bool { true }
}
