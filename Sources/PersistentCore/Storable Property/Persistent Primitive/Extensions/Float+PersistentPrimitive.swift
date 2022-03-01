//
//  Float+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Float: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .floatAttributeType
    
    public static var optional: Bool { false }
}
