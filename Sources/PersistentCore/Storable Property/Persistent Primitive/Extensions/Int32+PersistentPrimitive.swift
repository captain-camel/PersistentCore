//
//  Int32+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Int32: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .integer32AttributeType
    
    public static var optional: Bool { false }
}
