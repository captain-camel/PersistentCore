//
//  PersistentObject+PersistentEditable.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

protocol PersistentEditable: PersistentObject {}

extension PersistentEditable {
    func edit(updating: Bool = true, saving: Bool = DataStack.default.autosave, _ editor: (Self) -> Void) {
        let silentCopy = silentlyUpdatingCopy()
        
        editor(silentCopy)
        
        if updating {
            silentCopy.updateSilentlyUpdatedProperties()
        } else {
            silentCopy.propertiesUpdatedSilently.removeAll()
        }
        
        if saving && updating {
            DataStack.default.save()
        }
    }
    
    func set<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, to value: T, updating: Bool = DataStack.default.autosave, saving: Bool = true) {
        if !updating {
            let silentCopy = silentlyUpdatingCopy()
            
            silentCopy[keyPath: keyPath] = value
        } else {
            self[keyPath: keyPath] = value
        }
        
        if saving && updating {
            DataStack.default.save()
        }
    }
}

extension PersistentObject: PersistentEditable {}
