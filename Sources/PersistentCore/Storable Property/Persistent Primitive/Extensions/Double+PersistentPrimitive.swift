//
//  Double+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Double: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .doubleAttributeType
    
    public static var optional: Bool { false }
}
