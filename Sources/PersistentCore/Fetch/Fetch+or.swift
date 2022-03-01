//
//  File.swift
//  
//
//  Created by Cameron Delong on 2/24/22.
//

import CoreData
import SwiftUI

extension Fetch {
    /// Includes objects in fetch if a property is equal to a value.
    ///
    /// - Parameters:
    ///   - keyPath: The property that is being compared. Must be a `KeyPath` to the projected value of a ``Property/Stored`` property, not to the property itself.
    ///   - value: The value to compare against the property.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or<PropertyType>(_ keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, equals value: PropertyType) -> Fetch {
        addPredicate(predicate(
            key: Object.meta[keyPath: keyPath].unwrappedKey,
            operation: .equals,
            value: value.storablePrimitive
        ), combinationType: .or)
        return self
    }
    
    /// Includes objects in fetch if a property is equal to a value.
    ///
    /// - Parameters:
    ///   - keyPath: The property that is being compared. Must be a `KeyPath` to the projected value of a ``Property/Relationship`` property, not to the property itself.
    ///   - value: The value to compare against the property.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or<PropertyType>(_ keyPath: KeyPath<Object, Property<Object>.Relationship<PropertyType>>, equals value: PropertyType) -> Fetch {
        addPredicate(predicate(
            key: Object.meta[keyPath: keyPath].unwrappedKey,
            operation: .equals,
            value: value.relationshipPrimitive
        ), combinationType: .or)
        return self
    }
    
    /// Includes objects in fetch if a closure evaluates to `true`.
    ///
    /// - Important: Since this method required fetching every object from the data stack, it has significantly worse performance than other filter methods. Avoid using it if possible.
    ///
    /// - Parameter isIncluded: A predicate that returns `true` if the object passed as an argument should be included.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or(_ isIncluded: @escaping (Object) -> Bool) -> Fetch {
        addPredicate(NSPredicate { object, _ in
            return isIncluded(object as! Object)
        }, combinationType: .or)
        return self
    }
    
    /// Includes objects in fetch if a property is greater than a value.
    ///
    /// - Parameters:
    ///   - keyPath: The property that is being compared. Must be a `KeyPath` to the projected value of a ``Property/Stored`` property, not to the property itself. Must point to a property that conforms to `Comparable`.
    ///   - value: The value to compare against the property.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or<PropertyType: Comparable>(_ keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, greaterThan value: PropertyType) -> Fetch {
        addPredicate(predicate(
            key: Object.meta[keyPath: keyPath].unwrappedKey,
            operation: .greater,
            value: value.storablePrimitive
        ), combinationType: .or)
        return self
    }
    
    /// Includes objects in fetch if a property is greater than or equal to a value.
    ///
    /// - Parameters:
    ///   - keyPath: The property that is being compared. Must be a `KeyPath` to the projected value of a ``Property/Stored`` property, not to the property itself. Must point to a property that conforms to
    ///   `Comparable`.
    ///   - value: The value to compare against the property.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or<PropertyType: Comparable>(_ keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, greaterThanOrEqualTo value: PropertyType) -> Fetch {
        addPredicate(predicate(
            key: Object.meta[keyPath: keyPath].unwrappedKey,
            operation: .greaterEqual,
            value: value.storablePrimitive
        ), combinationType: .or)
        return self
    }
    
    /// Includes objects in fetch if a property is less than a value.
    ///
    /// - Parameters:
    ///   - keyPath: The property that is being compared. Must be a `KeyPath` to the projected value of a ``Property/Stored`` property, not to the property itself. Must point to a property that conforms to
    ///   `Comparable`.
    ///   - value: The value to compare against the property.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or<PropertyType: Comparable>(_ keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, lessThan value: PropertyType) -> Fetch {
        addPredicate(predicate(
            key: Object.meta[keyPath: keyPath].unwrappedKey,
            operation: .less,
            value: value.storablePrimitive
        ), combinationType: .or)
        return self
    }
    
    /// Includes objects in fetch if a property is less than or equal to value.
    ///
    /// - Parameters:
    ///   - keyPath: The property that is being compared. Must be a `KeyPath`  to the projected value of a ``Property/Stored`` property, not to the property itself. Must point to a property that conforms to
    ///   `Comparable`.
    ///   - value: The value to compare against the property.
    ///
    /// - Returns: The ``Fetch`` with the added filter.
    public func or<PropertyType: Comparable>(_ keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, lessThanOrEqualTo value: PropertyType) -> Fetch {
        addPredicate(predicate(
            key: Object.meta[keyPath: keyPath].unwrappedKey,
            operation: .lessEqual,
            value: value.storablePrimitive
        ), combinationType: .or)
        return self
    }
}
