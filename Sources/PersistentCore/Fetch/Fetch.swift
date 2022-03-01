//
//  Fetch.swift
//
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

/// A type representing a fetch operation from a data stack.
///
/// ``Fetch`` acts as a wrapper around an `NSFetchRequest`. Use it to fetch objects from a ``DataStack`` with ``DataStack/fetch(_:)`` or narrow the results of the ``Persistent`` property wrapper.
///
/// ### Filtering and Sorting
/// Chain calls to ``Fetch``'s `where`, `or`, and `sorted` methods to filter and sort objects. The filtering methods (`where` and `or`) act according to the order they are applied. `where` returns objects if they satisfy the previous conditions *and* the condition in the `where` call, and `or` returns objects if they satisfy the previous conditions *or* the condition in the `or` call.
///
/// ```swift
///     Fetch<Person>()
///         .where(\.$name, equals: "Olive")
///         .or(\.$name, equals: "Gus")
///         .sorted(by: \.$age)
/// ```
public struct Fetch<Object: PersistentObject> {
    /// The `NSFetchRequest` associated with this ``Fetch``.
    internal var fetchRequest: NSFetchRequest<NSManagedObject>
    
    /// Creates a new, empty ``Fetch``.
    public init() {
        fetchRequest = NSFetchRequest<NSManagedObject>(
            entityName: String(describing: Object.self)
        )
        fetchRequest.sortDescriptors = []
    }
    
    /// Performs this ``Fetch`` on the provided ``DataStack``, returning objects filtered and sorted according to the ``Fetch``.
    /// 
    /// - Parameter dataStack: The ``DataStack`` to fetch objects from.
    ///
    /// - Returns: The fetched objects, filtered and sorted according to the ``Fetch``.
    public func perform(on dataStack: DataStack) -> [Object] {
        dataStack.fetch(self)
    }
    
    /// A logical conjunction describing how to add an `NSPredicate` to a ``Fetch``.
    internal enum PredicateCombinationType {
        /// Both the new predicate or the ``Fetch``'s current predicate must evaluate to true.
        case and
        /// Either the new predicate or the ``Fetch``'s current predicate must evaluate to true.
        case or
    }
    
    /// Combined the current `NSPredicate` of the the `NSFetchRequest` with a given `NSPredicate`.
    ///
    /// - Parameters:
    ///   - predicate: The `NSPredicate` to combine with the current predicate.
    ///   - combinationType: The `PredicateCombinationType` to combine the predicates with.
    internal func addPredicate(
        _ predicate: NSPredicate,
        combinationType: PredicateCombinationType
    ) {
        if let currentPredicate = fetchRequest.predicate {
            switch combinationType {
            case .and:
                fetchRequest.predicate = NSCompoundPredicate(
                    andPredicateWithSubpredicates: [currentPredicate, predicate]
                )
            case .or:
                fetchRequest.predicate = NSCompoundPredicate(
                    orPredicateWithSubpredicates: [currentPredicate, predicate]
                )
            }
        } else {
            fetchRequest.predicate = predicate
        }
    }
    
    /// An operator used to compare values in an `NSPredicate`.
    enum PredicateOperator: String {
        case equals = "=="
        case greater = ">"
        case greaterEqual = ">="
        case less = "<"
        case lessEqual = "<="
    }
    
    /// Returns an `NSPredicate` from on a key to a property, an operation, and a value to compare against.
    internal func predicate<T>(key: String, operation: PredicateOperator, value: T) -> NSPredicate {
        switch value {
        case nil as Any?:
            return NSPredicate(format: "\(key) \(operation.rawValue) %@ == nil")
        default:
            return NSPredicate(format: "\(key) \(operation.rawValue) %@", argumentArray: [value])
        }
    }
}
