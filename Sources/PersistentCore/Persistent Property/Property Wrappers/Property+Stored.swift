//
//  Property+Stored.swift
//
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

extension Property {
    @propertyWrapper
    public class Stored<Property: StorableType>: PersistentProperty {
        var key: String?
        
        public var projectedValue: Stored { self }
        
        public var autosave: Bool?
        
        public init(autosave: Bool? = nil) {
            self.autosave = autosave
        }
        
        func propertyDescription(_ description: NSPropertyDescription?, iteration: Int) -> (description: NSPropertyDescription, complete: Bool) {
            let attributeDescription = NSAttributeDescription()
            attributeDescription.name = unwrappedKey
            attributeDescription.attributeType = Property.PrimitiveType.attributeType
            attributeDescription.isOptional = true
            
            return (description: attributeDescription, complete: true)
        }
        
        public static subscript(
            _enclosingInstance instance: Enclosing,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Property>,
            storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Stored>
        ) -> Property {
            get {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                return Property(storablePrimitive: instance.getValue(forKey: key))
            }
            set {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                instance.setValue(newValue.storablePrimitive, forKey: key)
                
                if instance[keyPath: storageKeyPath].autosave ?? instance.dataStack.autosave {
                    instance.dataStack.save()
                }
            }
        }
        
        @available(*, unavailable, message: "'@Stored' can only be applied to properties of subclasses of 'PersistentObject'")
        public var wrappedValue: Property {
            get { fatalError() }
            set { fatalError() }
        }
    }
}
