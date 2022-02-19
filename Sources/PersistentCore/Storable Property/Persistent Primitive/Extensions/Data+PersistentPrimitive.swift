//
//  Data+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Data: PersistentPrimitive {
    static let attributeType: NSAttributeType = .binaryDataAttributeType
    
    static var optional: Bool { false }
}
