//
//  String+PersistentPrimitive.swift
//  
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension String: PersistentPrimitive {
    static let attributeType: NSAttributeType = .stringAttributeType
    
    static var optional: Bool { false }
}
