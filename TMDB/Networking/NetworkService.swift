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
    static let baseURL = URL(string: "https://api.themoviedb.org/3/")
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/original/")
    
    static func buildURL(
        for path: String,
        relativeTo baseURL: URL?,
        queryItems: [URLQueryItem] = []
    ) throws -> URL {
        guard var url = URL(string: path, relativeTo: baseURL) else {
            throw NetworkError.badURL(message: "Malformed URL for path: **\(path)**")
        }
        url.append(queryItems: queryItems)
        url.append(queryItems: [URLQueryItem(name: "api_key", value: apiKey)])
        return url
    }

    /**
     Loads [themoviedb.org](https://developer.themoviedb.org/docs/getting-started) API key from `Secrets.yml` file
     
     The contents should be in the following format:
     ```yml
     api_key: YOUR_API_KEY
     ```
     */
    private static let apiKey: String = {
        let url = Bundle.main.url(forResource: "Secrets", withExtension: "yml")!
        let contents = try! String(contentsOf: url)
        return contents.split(separator: ":").last!.trimmingCharacters(in: .whitespacesAndNewlines)
    }()
    
    private let networking: Networking
    private let decoder: JSONDecoder
    
    /**
     A custom initializer required for unit testing while mocking the `URLSession` object.
     
     By using a default argument (in this case `.shared`) we can add dependency injection without
     making our app code more complicated.
     */
    init(using networking: Networking = URLSession.shared, with decoder: JSONDecoder = .init()) {
        self.networking = networking
        self.decoder = decoder
    }
    
    /**A generic function that fetches data from the given endpoint and decodes it into the provided type.*/
    func loadData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await networking.data(from: url)
        let response = try decoder.decode(T.self, from: data)
        return response
    }
}
