//
//  Pokemon+Equatable.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

extension Pokemon: Equatable {
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
}
