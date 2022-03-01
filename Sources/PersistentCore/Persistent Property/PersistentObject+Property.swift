//
//  PersistentObject+Property.swift
//
//
//  Created by Cameron Delong on 1/26/22.
//

public enum Property<Enclosing: PersistentObject> {}

public protocol PersistentPropertyEnclosing: PersistentObject {
    typealias Stored = Property<Self>.Stored
    typealias Relationship = Property<Self>.Relationship
}

extension PersistentObject: PersistentPropertyEnclosing {}
