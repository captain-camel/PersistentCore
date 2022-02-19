//
//  Int16+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Int16: PersistentPrimitive {
    static let attributeType: NSAttributeType = .integer16AttributeType
    
    static var optional: Bool { false }
}
