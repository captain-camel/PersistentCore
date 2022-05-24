//
//  PersistentObject+PersistentCreatable.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

//import CoreData
//
//protocol PersistentCreatable: PersistentObject {}
//
//extension PersistentCreatable {
//    // TODO: Rename dataStack to into
//    public static func create(_ initializer: (Self) -> Void, into dataStack: DataStack = .default, saving: Bool? = nil) -> Self {
//        let new = Self.init(
//            object: NSManagedObject(
//                entity: Self.entities[String(describing: Self.self)]!,
//                insertInto: dataStack.container.viewContext
//            ),
//            dataStack: dataStack
//        )
//        
//        let copy = new.silentlyUpdatingCopy()
//        
//        initializer(copy)
//        
//        if saving ?? dataStack.autosave {
//            dataStack.save()
//        }
//        
//        return new
//    }
//}
//
//extension PersistentObject: PersistentCreatable {}
