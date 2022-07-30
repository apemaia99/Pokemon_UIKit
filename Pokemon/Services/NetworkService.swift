//
//  NetworkService.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

actor NetworkService {
    
    static let shared = NetworkService()
    
    private var cache: [(url: URL, data: Data)] = []
    
    func fetchObject<T: Codable>(for url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw Error.request
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchData(for url: URL) async throws -> Data {
        
        if let founded = cache.first(where: { $0.url == url }) {
            print("Found in cache un-necessary download")
            return founded.data
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw Error.request
        }
        
        
        cache.append(
            (url: url, data: data)
        )
        print("downloaded and stored")
        return data
    }
}

extension NetworkService {
    enum Error: LocalizedError {
        case request
        case decode
    }
}
