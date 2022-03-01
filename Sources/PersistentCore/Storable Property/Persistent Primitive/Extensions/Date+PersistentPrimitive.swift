//
//  Date+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Date: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .dateAttributeType
    
    public static var optional: Bool { false }
}
