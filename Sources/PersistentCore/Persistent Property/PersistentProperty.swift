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

extension PersistentProperty {
    var unwrappedKey: String {
        guard let key = key else {
            fatalError("`key` property of `\(String(describing: Self.self))` accessed before being set")
        }
        
        return key
    }
}
