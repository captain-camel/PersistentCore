//
//  PersistentObject+PersistentCreatable.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

protocol PersistentCreatable: PersistentObject {}

extension PersistentCreatable {
    static func create(_ initializer: (Self) -> Void, saving: Bool = DataStack.default.autosave) -> Self {
        let new = Self.init(
            object: NSManagedObject(
                entity: Self.entities[String(describing: Self.self)]!,
                insertInto: DataStack.default.container.viewContext
            )
        )
        
        let copy = new.silentlyUpdatingCopy()
        
        initializer(copy)
        
        if saving {
            DataStack.default.save()
        }
        
        return new
    }
}

extension PersistentObject: PersistentCreatable {}
