//
//  File.swift
//  Practica2_Bebidas
//
//  Created by Jorge Armando Avila Estrada on 02/03/23.
//

import Foundation

struct Bebida: Codable {
    var directions: String
    var ingredients: String
    var name: String
    var img: String
    
    init(name: String, directions: String, ingredients: String, img: String) {
        self.name   = name
        self.directions = directions
        self.ingredients  = ingredients
        self.img = img
    }
}



// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
