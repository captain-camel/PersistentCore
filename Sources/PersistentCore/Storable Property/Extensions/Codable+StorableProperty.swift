//
//  Codable+StorableProperty.swift
//  
//
//  Created by Cameron Delong on 2/18/22.
//

import Foundation

extension StorableType where Self: Codable {
    init(storablePrimitive: Data) {
        self = try! JSONDecoder().decode(Self.self, from: storablePrimitive)
        print("Using codable")
    }
    
    var storablePrimitive: Data {
        print("Using codable")
        return try! JSONEncoder().encode(self)
    }
}
