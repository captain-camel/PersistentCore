//
//  Codable+StorableType.swift
//
//
//  Created by Cameron Delong on 2/18/22.
//

import Foundation

extension StorableType where Self: Codable {
    public init(storablePrimitive: Data) {
        self = try! JSONDecoder().decode(Self.self, from: storablePrimitive)
        print("Using codable")
    }
    
    public var storablePrimitive: Data {
        print("Using codable")
        return try! JSONEncoder().encode(self)
    }
}
