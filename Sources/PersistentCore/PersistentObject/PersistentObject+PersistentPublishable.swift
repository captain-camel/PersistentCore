//
//  PersistentObject+PersistentPublishable.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

protocol PersistentPublishable: PersistentObject {}

extension PersistentPublishable {
    public static func publisher(callback: @escaping EntityPublisher<Self>.Callback) -> EntityPublisher<Self> {
        return EntityPublisher(callback: callback)
    }
}

extension PersistentObject: PersistentPublishable {}
