//
//  String+PersistentPrimitive.swift
//
//
//  Created by Cameron Delong on 1/27/22.
//

import CoreData

extension String: PersistentPrimitive {
    public static let attributeType: NSAttributeType = .stringAttributeType
    
    public static var optional: Bool { false }
}
