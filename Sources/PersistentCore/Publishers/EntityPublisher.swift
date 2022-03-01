//
//  EntityPublisher.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

import CoreData
import Combine

public class EntityPublisher<Object: PersistentObject>: Cancellable {
    /// The fetch request that is executed to fetch the objects.
    private let fetchRequest: NSFetchRequest<NSManagedObject>
    
    private let fetchedResultsController: NSFetchedResultsController<NSManagedObject>
    private var delegate: FetchedResultsControllerDelegate!
    
    private let dataStack: DataStack
    
    public typealias Callback = ([Object]) -> Void
    
    public init(fetch: Fetch<Object> = .init(), dataStack: DataStack = .default, callback: @escaping Callback) {
        fetchRequest = fetch.fetchRequest
        
        delegate = FetchedResultsControllerDelegate(dataStack: dataStack, callback: callback)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataStack.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.dataStack = dataStack
        
        fetchedResultsController.delegate = delegate
        
        try! fetchedResultsController.performFetch()
        
        delegate.callback = callback
    }
    
    public func cancel() {
        delegate.callback = nil
    }
    
    /// Manually fetches objects from the persistent store and calls the callback with the updated objects.
    public func update() {
        do {
            if let callback = delegate.callback {
                try fetchedResultsController.performFetch()
                
                callback(fetchedResultsController.fetchedObjects!.map { Object(object: $0, dataStack: dataStack) })
            }
        } catch {
            fatalError("Failed to fetch object: \(error)")
        }
    }

    private class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
        let dataStack: DataStack
        var callback: Callback?
        
        init(dataStack: DataStack, callback: @escaping Callback) {
            self.dataStack = dataStack
            self.callback = callback
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let callback = callback {
                let values = controller.fetchedObjects!.map { Object(object: ($0 as! NSManagedObject), dataStack: dataStack) }
                
                callback(values)
            }
        }
    }
}
