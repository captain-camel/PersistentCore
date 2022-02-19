//
//  Int32+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Int32: PersistentPrimitive {
    static let attributeType: NSAttributeType = .integer32AttributeType
    
    static var optional: Bool { false }
}
