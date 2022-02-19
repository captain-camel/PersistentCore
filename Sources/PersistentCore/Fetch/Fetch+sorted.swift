//
//  Fetch+sorted.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData

extension Fetch {
    func sorted<Property>(by keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, _ order: SortOrder = .ascending) -> Fetch {
        if fetchRequest.sortDescriptors == nil {
            fetchRequest.sortDescriptors = []
        }
        
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: keyPath, ascending: order == .ascending ? true : false))
        return self
    }
    
    func sorted<Property>(by keyPath: KeyPath<Object, PersistentObject.Stored<Property>>, _ comparator: @escaping (Property, Property) -> ComparisonResult) {
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(keyPath: keyPath, ascending: true, comparator: { first, second in
            switch comparator(first as! Property, second as! Property) {
            case .ascending:
                return .orderedAscending
            case .descending:
                return .orderedDescending
            case .equal:
                return .orderedSame
            }
        }))
    }
    
    enum ComparisonResult {
        case ascending
        case descending
        case equal
    }
    
    enum SortOrder {
        case ascending
        case descending
    }
}
