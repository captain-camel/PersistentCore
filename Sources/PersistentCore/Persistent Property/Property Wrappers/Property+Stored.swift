//
//  Property+Stored.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

extension Property {
    @propertyWrapper
    class Stored<Property: StorableProperty>: PersistentProperty {
        let autosave: Bool
        
        var key: String?
        
        init(autosave: Bool = true) {
            self.autosave = autosave
        }
        
        var projectedValue: Stored { self }
        
        var propertyDescription: NSPropertyDescription {
            let attributeDescription = NSAttributeDescription()
            attributeDescription.name = unwrappedKey
            attributeDescription.attributeType = Property.PrimitiveType.attributeType
            attributeDescription.isOptional = true
            
            return attributeDescription
        }
        
        static subscript(
            _enclosingInstance instance: Enclosing,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Property>,
            storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Stored>
        ) -> Property {
            get {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                instance.managedObject.willAccessValue(forKey: key)
                defer { instance.managedObject.didAccessValue(forKey: key) }
                
                return Property(primitive: instance.managedObject.value(forKey: key) as! Property.PrimitiveType)
            }
            set {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                instance.managedObject.willChangeValue(forKey: key)
                defer { instance.managedObject.didChangeValue(forKey: key) }
                
                switch newValue.primitive {
                case nil as Any?:
                    instance.managedObject.setNilValueForKey(key)
                default:
                    instance.managedObject.setValue(newValue.primitive, forKey: key)
                }
                
                if instance[keyPath: storageKeyPath].autosave {
                    try! instance.managedObject.managedObjectContext!.save()
                }
            }
        }
        
        @available(*, unavailable, message: "@Stored can only be applied to properties of PersistentObject subclasses")
        var wrappedValue: Property {
            get { fatalError() }
            set { fatalError() }
        }
    }
}
