//
//  PokemonManager.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

@MainActor
final class PokemonManager: ObservableObject {
    
    private let networkService = NetworkService()
    
    private var pokemonIndex: PokemonIndex?
    @Published private(set) var pokemonList: [Pokemon] = []
    @Published private(set) var pokemonFiltered: [Pokemon] = []
    private var orderingMode: OrderMode = .standard
    
    private func getData<T:Codable>(by url: URL?) async throws -> T {
        guard let url = url else {
            throw Error.invalidURL
        }
        return try await networkService.fetchObject(for: url)
    }
    
    private func getPokemons() async throws -> [Pokemon] {
        //FIXME: - add pokemond index as input paremeter
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            
            var results: [Pokemon] = []
            
            guard let pokemonIndex = pokemonIndex else {
                throw Error.missingPokemonIndex
            }
            
            for url in pokemonIndex.results.map({ $0.url }) {
                group.addTask() {
                    return try await self.getData(by: url)
                }
            }
            
            for try await pokemon in group {
                results.append(pokemon)
            }
            return results
        }
    }
    
    func loadMore(firstCall: Bool = false) async {
        do {
            pokemonIndex = try await getData(
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
    }
}
