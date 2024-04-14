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
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
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
    
    static func buildURL(for path: String, relativeTo baseURL: URL, queryItems: [URLQueryItem] = []) throws -> URL {
        var url = baseURL.appendingPathComponent(path, conformingTo: .url)
        url.append(queryItems: queryItems)
        url.append(queryItems: [URLQueryItem(name: "api_key", value: apiKey)])
        return url
    }
    
    private let networking: Networking
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    /**
     A custom initializer required for unit testing while mocking the `URLSession` object.
     
     By using a default argument (in this case `.shared`) we can add dependency injection without
     making our app code more complicated.
     */
    init(
        using networking: Networking = URLSession.shared,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.networking = networking
        self.decoder = decoder
        self.encoder = encoder
    }
    
    /**
     A generic function that fetches data from the given endpoint and decodes it into the provided type.
     */
    func loadData<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await networking.data(from: url)
        let response = try decoder.decode(T.self, from: data)
        return response
    }
    
    /**
     A generic function that fetches data from the documents directory for the given file name and decodes
     it into the provided type.
     */
    func loadData<T: Decodable>(from file: String) throws -> T {
        let url = URL.documentsDirectory.appending(path: file)
        let data = try Data(contentsOf: url)
        let response = try decoder.decode(T.self, from: data)
        return response
    }
    
    /**
     A generic function that writes data to the documents directory for the given file name.
     - `.atomic` write options makes sure that all of the data is written at the same time
     - `.completeFileProtection` saves the file in an encrypted format
     */
    func save<T: Encodable>(result: T, to file: String) throws {
        let url = URL.documentsDirectory.appending(path: file)
        let data = try encoder.encode(result)
        try data.write(to: url, options: [.atomic, .completeFileProtection])
    }
}
