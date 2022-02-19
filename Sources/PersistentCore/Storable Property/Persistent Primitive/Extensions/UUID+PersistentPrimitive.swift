//
//  UUID+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension UUID: PersistentPrimitive {
    static let attributeType: NSAttributeType = .UUIDAttributeType
    
    static var optional: Bool { false }
}
