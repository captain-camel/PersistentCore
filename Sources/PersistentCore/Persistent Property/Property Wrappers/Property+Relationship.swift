//
//  Property+Relationship.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

extension Property {
    @propertyWrapper
    class Relationship<Property: RelationshipType>: PersistentProperty {
        
        enum Kind {
            case toOne
            case toMany
        }
        
        var key: String?
        
        var autosave: Bool
        
        init(deleteRule: DeleteRule = .nullify, autosave: Bool = true) {
            self.deleteRule = deleteRule
            self.autosave = autosave
        }
        
        typealias Destination = Property.Destination
        
        let deleteRule: DeleteRule
        
        var projectedValue: Relationship { self }
        
        var propertyDescription: NSPropertyDescription {
            let relationshipDescription = NSRelationshipDescription()
            
            relationshipDescription.name = unwrappedKey
            relationshipDescription.destinationEntity = Destination.entities[String(describing: Destination.self)]!
            relationshipDescription.deleteRule = deleteRule.nsDeleteRule
            relationshipDescription.isOrdered = Property.ordered
            relationshipDescription.minCount = 0
            relationshipDescription.maxCount = Property.relationshipKind == .toOne ? 1 : 0
            
            var inverseRelationship: NSRelationshipDescription? = nil
            for property in Destination.entities[String(describing: Destination.self)]!.properties {
                if let relationship = property as? NSRelationshipDescription {
                    if relationship.destinationEntity == Enclosing.entities[String(describing: Enclosing.self)]! {
                        inverseRelationship = relationship
                    }
                }
            }
            
            relationshipDescription.inverseRelationship = inverseRelationship
            
            return relationshipDescription
        }
        
        static subscript(
            _enclosingInstance instance: Enclosing,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Property>,
            storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relationship>
        ) -> Property {
            get {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                instance.managedObject.willAccessValue(forKey: key)
                defer { instance.managedObject.didAccessValue(forKey: key) }
                
                return Property(relationshipPrimitive: (instance.managedObject.value(forKey: key) as! Property.RawType))
            }
            set {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                instance.managedObject.willChangeValue(forKey: key)
                defer { instance.managedObject.didChangeValue(forKey: key) }
                
                switch newValue.relationshipPrimitive {
                case nil as NSManagedObject?:
                    instance.managedObject.setNilValueForKey(key)
                default:
                    instance.managedObject.setValue(newValue.relationshipPrimitive, forKey: key)
                }
                
                if instance[keyPath: storageKeyPath].autosave {
                    try! instance.managedObject.managedObjectContext!.save()
                }
            }
        }
        
        @available(*, unavailable, message: "@Relationship can only be applied to properties of PersistentObject subclasses")
        var wrappedValue: Property {
            get { fatalError() }
            set { fatalError() }
        }
        
        enum DeleteRule {
            case noAction
            case nullify
            case cascade
            case deny
            
            var nsDeleteRule: NSDeleteRule {
                switch self {
                case .noAction:
                    return .noActionDeleteRule
                case .nullify:
                    return .nullifyDeleteRule
                case .cascade:
                    return .cascadeDeleteRule
                case .deny:
                    return .denyDeleteRule
                }
            }
        }
    }
}

