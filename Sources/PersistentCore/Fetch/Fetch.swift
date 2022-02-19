//
//  Fetch.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

import CoreData

public struct Fetch<Object: PersistentObject> {
    var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: String(describing: Object.self))
    
    enum PredicateCombinationType {
        case and
        case or
    }
    
    func addPredicate(_ predicate: NSPredicate, combinationType: PredicateCombinationType) {
        if let currentPredicate = fetchRequest.predicate {
            switch combinationType {
            case .and:
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [currentPredicate, predicate])
            case .or:
                fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [currentPredicate, predicate])
            }
        } else {
            fetchRequest.predicate = predicate
        }
    }
}
