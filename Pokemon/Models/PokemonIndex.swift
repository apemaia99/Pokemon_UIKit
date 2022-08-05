//
//  PokemonIndex.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

struct PokemonIndex: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [PokemonAnchor]
}
