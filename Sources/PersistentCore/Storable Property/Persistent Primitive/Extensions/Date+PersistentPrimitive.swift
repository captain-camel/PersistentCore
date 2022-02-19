//
//  Date+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension Date: PersistentPrimitive {
    static let attributeType: NSAttributeType = .dateAttributeType
    
    static var optional: Bool { false }
}
