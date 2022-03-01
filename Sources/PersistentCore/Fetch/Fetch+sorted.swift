//
//  File.swift
//  
//
//  Created by Cameron Delong on 2/24/22.
//

import CoreData

extension Fetch {
    /// Sorts objects returned by fetch by a property.
    ///
    /// - Parameters:
    ///   - keyPath: The property to use for sorting, which must conform to `Comparable`.
    ///   - order: The ``SortOrder`` to sort objects into. Either ``SortOrder/ascending`` or ``SortOrder/descending``.
    ///
    /// - Returns: The updated ``Fetch``.
    public func sorted<PropertyType: Comparable>(by keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, _ order: SortOrder = .ascending) -> Fetch {
        if fetchRequest.sortDescriptors == nil {
            fetchRequest.sortDescriptors = []
        }
        
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: keyPath, ascending: order == .ascending ? true : false))
        return self
    }
    
    /// Sorts objects returned by fetch by a property using a comparator.
    ///
    /// - Parameters:
    ///   - keyPath: The property to use for sorting, which must conform to `Comparable`.
    ///   - comparator: A closure that returns the comparison result of the arguments.
    ///
    /// - Returns: The updated ``Fetch``.
    public func sorted<PropertyType: Comparable>(by keyPath: KeyPath<Object, Property<Object>.Stored<PropertyType>>, _ comparator: @escaping (PropertyType, PropertyType) -> ComparisonResult) {
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: keyPath, ascending: true, comparator: { first, second in
            switch comparator(first as! PropertyType, second as! PropertyType) {
            case .ascending:
                return .orderedAscending
            case .descending:
                return .orderedDescending
            case .equal:
                return .orderedSame
            }
        }))
    }
    
    /// Describes the order of two values.
    public enum ComparisonResult {
        /// The first value is less than the second value.
        case ascending
        /// The second value is less than the second value.
        case descending
        /// The values are equal.
        case equal
    }
    
    /// The order in which values can be sorted.
    public enum SortOrder {
        /// Each successive value is greater than or equal to the last.
        case ascending
        /// Each successive value is less tahn or equal to the last
        case descending
    }
}
