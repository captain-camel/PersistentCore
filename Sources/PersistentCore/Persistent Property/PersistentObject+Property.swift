//
//  PersistentObject+Property.swift
//  
//
//  Created by Cameron Delong on 1/26/22.
//

enum Property<Enclosing: PersistentObject> {}

protocol PersistentPropertyEnclosing: PersistentObject {
    typealias Stored = Property<Self>.Stored
    typealias Relationship = Property<Self>.Relationship
}

extension PersistentObject: PersistentPropertyEnclosing {}
