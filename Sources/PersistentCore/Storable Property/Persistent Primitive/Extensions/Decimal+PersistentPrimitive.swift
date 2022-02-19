//
//  Decimal+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Decimal: PersistentPrimitive {
    static let attributeType: NSAttributeType = .decimalAttributeType
    
    static var optional: Bool { false }
}
