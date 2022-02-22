//
//  Bool+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Bool: PersistentPrimitive {
    static let attributeType: NSAttributeType = .booleanAttributeType
    
    static var optional: Bool { false }
}
