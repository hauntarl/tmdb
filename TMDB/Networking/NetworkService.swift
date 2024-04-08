//
//  NetworkManager.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Foundation

/**A generic network manager that loads data from a given api endpoint.*/
struct NetworkService {
    static let shared = Self()
    
    static let posterBaseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
    static let baseURL = URL(string: "https://api.themoviedb.org/3/movie/")
    static let apiKey: String = {
        let url = Bundle.main.url(forResource: "Secrets", withExtension: "yml")!
        let contents = try! String(contentsOf: url)
        return contents.split(separator: ":").last!.trimmingCharacters(in: .whitespacesAndNewlines)
    }()
    
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
