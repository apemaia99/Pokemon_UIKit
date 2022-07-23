//
//  Pokemon+Moves.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

extension Pokemon {
    struct Move: Identifiable, Codable {
        let id = UUID()
        var detail: DetailedMove
        
        enum CodingKeys: String, CodingKey {
            case detail = "move"
        }
    }
}

extension Pokemon.Move {
    struct DetailedMove: Codable {
        var name: String
        var url: URL
    }
}
