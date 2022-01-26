//
//  PersistentProperty.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

protocol PersistentProperty: AnyObject {
    var propertyDescription: NSPropertyDescription { get }
    
    var key: String? { get set }
}
