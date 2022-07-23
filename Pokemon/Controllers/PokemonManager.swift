//
//  PokemonManager.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation
import UIKit

final class PokemonManager {
    
    private let networkService = NetworkService()
    
    private var pokemonIndex: PokemonIndex?
    private(set) var pokemonList: [Pokemon] = []
    private var pokemonFiltered: [Pokemon] = []
    private var orderingMode: OrderMode = .standard
    
    private func getPokemonIndex(by url: URL?) async throws -> PokemonIndex {
        guard let url = url else {
            throw Error.invalidURL
        }
        return try await networkService.fetchObject(for: url)
    }
    
    private func getPokemon(by url: URL?) async throws -> Pokemon {
        guard let url = url else {
            throw Error.invalidURL
        }
        return try await networkService.fetchObject(for: url)
    }
    
    private func getPokemons() async throws -> [Pokemon] {
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            
            var results: [Pokemon] = []
            
            guard let pokemonIndex = pokemonIndex else {
                throw Error.missingPokemonIndex
            }
            
            for url in pokemonIndex.results.map({ $0.url }) {
                group.addTask() {
                    return try await self.getPokemon(by: url)
                }
            }
            
            for try await pokemon in group {
                results.append(pokemon)
            }
            return results
        }
    }
    
    func fetchImage(by url: URL) async throws -> UIImage {
        async let data = networkService.fetchData(for: url)
        guard let image = try await UIImage(data: data) else {
            throw Error.imageParsing
        }
        
        return image
    }
    
    func loadMore(firstCall: Bool = false) async {
        do {
            pokemonIndex = try await getPokemonIndex(
                by: firstCall ? URL(string: "https://pokeapi.co/api/v2/pokemon/")! : self.pokemonIndex?.next
            )
            pokemonList.append(
                contentsOf: try await getPokemons()
            )
            orderList(by: orderingMode)
        } catch {
            print(error)
        }
    }
    
    func orderList(by order: OrderMode) {
        switch order {
        case .reverse:
            pokemonList.sort(by: { $0.name > $1.name })
        case .alphabetical:
            pokemonList.sort(by: { $0.name < $1.name })
        case .standard:
            pokemonList.sort(by: { $0.id < $1.id })
        }
    }
    
    func filterList(by text: String) {
        pokemonFiltered = pokemonList.filter({ $0.name.localizedCaseInsensitiveContains(text) })
    }
}

extension PokemonManager {
    enum OrderMode {
        case reverse
        case alphabetical
        case standard
    }
    
    enum Error: LocalizedError {
        case invalidURL
        case missingPokemonIndex
        case imageParsing
    }
}
