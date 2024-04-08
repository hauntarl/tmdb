//
//  NetworkManager.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Foundation

/**A generic network manager that loads data from a given api endpoint.*/
struct NetworkManager {
    static let shared = Self()

    private let networking: Networking
    
    /**
     A custom initializer required for unit testing while mocking the `URLSession` object.
     
     By using a default argument (in this case `.shared`) we can add dependency injection without
     making our app code more complicated.
     */
    init(using networking: Networking = URLSession.shared) {
        self.networking = networking
    }
    
    /**A generic function that fetches data from the given endpoint and decodes it into the provided type.*/
    func loadData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await networking.data(from: url)
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
