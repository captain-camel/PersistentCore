//
//  EntityPublisher.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData
import Combine

class EntityPublisher<Object: PersistentObject> {
    /// The fetch request that is executed to fetch the objects.
    private let fetchRequest: NSFetchRequest<NSManagedObject>
    
    private let fetchedResultsController: NSFetchedResultsController<NSManagedObject>
    private var delegate: FetchedResultsControllerDelegate!
    
    typealias Callback = ([Object]) -> Void
    
    func subscribe(_ callback: @escaping Callback) {
        delegate.callback = callback
    }
    
    init(_ fetch: Fetch<Object> = .init(), dataStack: DataStack = .default) {
        fetchRequest = fetch.fetchRequest
        
        delegate = FetchedResultsControllerDelegate()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataStack.default.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = delegate
        
        try! fetchedResultsController.performFetch()
    }
    
    /// Manually fetches objects from the persistent store and calls the callback with the updated objects.
    func fetch() {
        let managedObjectContext = DataStack.default.container.viewContext
        
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest).map { Object(object: $0) }
            
            delegate.callback?(fetchedObjects)
        } catch {
            fatalError("Failed to fetch object: \(error)")
        }
    }

    private class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        var callback: Callback?
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            let values = controller.fetchedObjects!.map { Object(object: ($0 as! NSManagedObject)) }
            
            callback?(values)
        }
    }
}
