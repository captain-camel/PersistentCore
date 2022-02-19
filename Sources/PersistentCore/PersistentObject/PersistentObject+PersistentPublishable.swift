//
//  PersistentObject+PersistentPublishable.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

protocol PersistentPublishable: PersistentObject {}

extension PersistentPublishable {
    static func publisher() ->EntityPublisher<Self> {
        return EntityPublisher()
    }
}

extension PersistentObject: PersistentPublishable {}
