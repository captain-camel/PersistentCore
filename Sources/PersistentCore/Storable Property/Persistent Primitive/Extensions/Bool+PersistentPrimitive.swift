//
//  Bool+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Bool: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .booleanAttributeType
    
    public static var optional: Bool { false }
}
