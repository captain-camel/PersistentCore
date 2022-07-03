//
//  Persistent.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

import SwiftUI

/// A property wrapper that retrieves ``PersistentObject``s from a data
@propertyWrapper
public struct Persistent<T: PersistentObject>: DynamicProperty {
    /// The objects retrieves from the persistent store.
    public var wrappedValue: [T] { proxy.objects }

    /// A proxy value responsible for actually storing the values.
    @ObservedObject private var proxy: Proxy

    private var publisher: EntityPublisher<T>!

    /// Creates an instance of ``Persistent`` based on a ``Fetch`` clause.
    ///
    /// - Parameters:
    ///   - fetch: A ``Fetch`` clause describing the type to fetch, and optionally a predicate and sort description to customize the resulting objects.
    ///   - updatePolicy: Describes when to refresh fetched objects and update the enclosing `View`.
    ///     - term `always`: Updates any time there is a change to the persistent store.
    ///     - term `onSave`: Updates when the ``DataStack`` that the objects are fetched from is saved using ``DataStack/save()``.
    ///   - dataStack: The ``DataStack`` to fetch objects from. Uses ``DataStack/default`` by default.
    ///
    public init(_ fetch: Fetch<T>, dataStack: DataStack = .default) {
        proxy = .init()
        
        publisher = EntityPublisher(fetch: fetch, dataStack: dataStack) { [proxy] objects in
            proxy.objects = objects
        }
        
        update()
    }

    /// Manually updates objects with values fetched from the data stack.
    // TODO: Name conflicts with DynamicProperty.update()?
//    public func update() {
//        publisher.update()
//    }
}

extension Persistent {
    /// A class that stores the objects fetched from Core Data and updates the property wrapper when there is a change.
    private class Proxy: ObservableObject {
        /// The stored objects.
        @Published var objects: [T] = []
    }
}
