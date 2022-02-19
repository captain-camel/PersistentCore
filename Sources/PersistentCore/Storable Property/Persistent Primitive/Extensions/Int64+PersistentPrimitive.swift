//
//  Int64+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Int64: PersistentPrimitive {
    static let attributeType: NSAttributeType = .integer64AttributeType
    
    static var optional: Bool { false }
}
