//
//  Property+Relationship.swift
//
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

extension Property {
    /// A property wrapper representing a relationship between ``PersistentObject``s.
    ///
    /// Use a relationship to give a type one or more associated values of another ``PersistentObject`` type.
    ///
    /// ```swift
    /// class Person: PersistentObject {
    ///     @Relationship var pets: Set<Pet>
    /// }
    /// ```
    ///
    /// ``Relationship`` can store any type that conforms to ``RelationshipType``, and the type of the property determines its behavior.
    /// - `Set`: An unordered one-to-many relationship.
    /// - `Array`: An ordered one-to-many relationship.
    /// - `Optional`: An optional one-to-one relationship.
    ///
    /// - Note: Currently, ``Relationship`` finds its inverse relationship by looking at the first ``Relationship`` property of the destination object. This means that multiple relationships between two objects might not work properly.
    @propertyWrapper
    public class Relationship<Property: RelationshipType>: PersistentProperty {
        public enum Kind {
            case toOne
            case toMany
        }
        
        internal var key: String?
        
        private var autosave: Bool
        
        public init(deleteRule: DeleteRule = .nullify, autosave: Bool = true) {
            self.deleteRule = deleteRule
            self.autosave = autosave
        }
        
        public typealias Destination = Property.Destination
        
        let deleteRule: DeleteRule
        
        public var projectedValue: Relationship { self }
        
        func propertyDescription(_ description: NSPropertyDescription?, iteration: Int) -> (description: NSPropertyDescription, complete: Bool) {
            let relationshipDescription = description.map { $0 as! NSRelationshipDescription }
            
            switch iteration {
            case 0:
                let relationshipDescription = NSRelationshipDescription()
                
                relationshipDescription.name = unwrappedKey
                relationshipDescription.destinationEntity = Destination.entities[String(describing: Destination.self)]!
                relationshipDescription.deleteRule = deleteRule.nsDeleteRule
                relationshipDescription.isOrdered = Property.ordered
                relationshipDescription.minCount = 0
                relationshipDescription.maxCount = Property.relationshipKind == .toOne ? 1 : 0
                
                return (description: relationshipDescription, complete: false)
                
            case 1:
                var inverseRelationship: NSRelationshipDescription? = nil
                for property in Destination.entities[String(describing: Destination.self)]!.properties {
                    if let relationship = property as? NSRelationshipDescription {
                        if relationship.destinationEntity == Enclosing.entities[String(describing: Enclosing.self)]! {
                            inverseRelationship = relationship
                        }
                    }
                }
                
                guard let inverseRelationship = inverseRelationship else {
                    fatalError("Failed to find inverse relationship for `\(String(describing: Enclosing.self)).\(unwrappedKey)`. This most likely means that you haven't defined a property with `@\(String(describing: Self.self))` in `\(String(describing: Destination.self))`")
                }
                
                relationshipDescription?.inverseRelationship = inverseRelationship
                
                return (description: relationshipDescription!, complete: true)
                
            default:
                guard let description = description else {
                    fatalError("\(String(describing: Self.self)).\(#function) reached default case before returning non-nil property description.")
                }
                
                return (description: description, complete: true)
            }
            
        }
        
        public static subscript(
            _enclosingInstance instance: Enclosing,
            wrapped wrappedKeyPath: ReferenceWritableKeyPath<Enclosing, Property>,
            storage storageKeyPath: ReferenceWritableKeyPath<Enclosing, Relationship>
        ) -> Property {
            get {
                let key = instance[keyPath: storageKeyPath].unwrappedKey
                
                instance.managedObject.willAccessValue(forKey: key)
                defer { instance.managedObject.didAccessValue(forKey: key) }
                
                return Property(relationshipPrimitive: (instance.managedObject.value(forKey: key) as! Property.RawType), dataStack: instance.dataStack)
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
        
        @available(*, unavailable, message: "'@Relationship' can only be applied to properties of subclasses of 'PersistentObject'")
        public var wrappedValue: Property {
            get { fatalError() }
            set { fatalError() }
        }
        
        public enum DeleteRule {
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

