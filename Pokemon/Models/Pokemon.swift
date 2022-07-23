//
//  Pokemon.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    var id: Int
    var name: String
    var height: Int
    var weight: Int
    var moves: [Move]
    var sprites: Sprites
}
