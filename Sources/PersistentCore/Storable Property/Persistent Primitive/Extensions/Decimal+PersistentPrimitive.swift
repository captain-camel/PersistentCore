//
//  Decimal+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Decimal: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .decimalAttributeType
    
    public static var optional: Bool { false }
}
