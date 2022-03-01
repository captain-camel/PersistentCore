//
//  Data+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Data: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .binaryDataAttributeType
    
    public static var optional: Bool { false }
}
