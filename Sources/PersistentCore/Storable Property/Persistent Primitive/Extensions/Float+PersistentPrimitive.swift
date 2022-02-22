//
//  Float+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Float: PersistentPrimitive {
    static let attributeType: NSAttributeType = .floatAttributeType
    
    static var optional: Bool { false }
}
