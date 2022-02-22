//
//  Double+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Double: PersistentPrimitive {
    static let attributeType: NSAttributeType = .doubleAttributeType
    
    static var optional: Bool { false }
}
