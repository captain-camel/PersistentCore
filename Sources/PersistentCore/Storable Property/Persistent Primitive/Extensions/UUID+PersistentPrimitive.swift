//
//  UUID+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension UUID: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .UUIDAttributeType
    
    public static var optional: Bool { false }
}
