//
//  PersistentObject+PersistentEditable.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

protocol PersistentEditable: PersistentObject {}

extension PersistentEditable {
    public func edit(updating: Bool = true, saving: Bool? = nil, _ editor: (Self) -> Void) {
        let silentCopy = silentlyUpdatingCopy()
        
        editor(silentCopy)
        
        if updating {
            silentCopy.updateSilentlyUpdatedProperties()
        } else {
            silentCopy.resetPropertiesUpdatingSilently()
        }
        
        if (saving ?? dataStack.autosave) && updating {
            try! managedObject.managedObjectContext!.save()
        }
    }
    
    public func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T, updating: Bool = true, saving: Bool? = nil) {
        if !updating {
            let silentCopy = silentlyUpdatingCopy()
            
            silentCopy[keyPath: keyPath] = value
        } else {
            self[keyPath: keyPath] = value
        }
        
        if (saving ?? dataStack.autosave) && updating {
            try! managedObject.managedObjectContext!.save()
        }
    }
}

extension PersistentObject: PersistentEditable {}
