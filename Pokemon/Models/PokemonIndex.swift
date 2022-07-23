//
//  PokemonIndex.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

struct PokemonIndex: Codable {
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [PokemonAnchor]
}
