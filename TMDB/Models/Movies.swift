//
//  Movies.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

/**
 `Movies` represents an aggregate model that is responsible for providing movie results
 like **now playing, popular, top-rated, and upcoming** from the
 [themoviedb.org](https://developer.themoviedb.org/reference/intro/getting-started) api.
 */
struct Movies: Decodable, Equatable {
    let results: [Movie]
    
    // Factory method that fetches now playing movies
    static var nowPlaying: [Movie] { get async throws {
        let params = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        let url = try NetworkService.buildURL(
            for: "/movie/now_playing",
            relativeTo: NetworkService.baseURL,
            queryItems: params
        )
        let movies: Self = try await NetworkService.shared.loadData(from: url)
        await ImageCache.shared.loadImages(from: movies.results.map({ $0.posterURL }))
        return movies.results
    }}
    
    // Factory method that fetches favorite movies from the app's documents directory
    static var favorites: [Movie] { get async throws {
        let movies: [Movie] = try NetworkService.shared.loadData(from: "favorites.json")
        await ImageCache.shared.loadImages(from: movies.map({ $0.posterURL }))
        return movies
    }}
    
    // Factory method that saves the list of favorite movies into app's documents directory
    static func save(favorites: [Movie]) throws {
        try NetworkService.shared.save(result: favorites, to: "favorites.json")
    }
    
    // Factory method that fetches movies based on search query
    static func search(query: String, includeAdult: Bool = true) async throws -> [Movie] {
        let params = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: String(includeAdult)),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        let url = try NetworkService.buildURL(
            for: "/search/movie",
            relativeTo: NetworkService.baseURL,
            queryItems: params
        )
        let movies: Self = try await NetworkService.shared.loadData(from: url)
        await ImageCache.shared.loadImages(from: movies.results.map({ $0.posterURL }))
        return movies.results
    }
}

/**
 `Movie` represents the internal structure of a `Movies` aggregate model that is consumed by the view.
 It also provides a method to fetch movies similar to the current movie as it directly depends
 on the `id` attribute of a movie.
 
 It utilizes a custom decoding strategy in order to transform api response into fields
 that can be directly consumed by the views.
 */
struct Movie: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let posterURL: URL?
    let releaseYear: Int?
    let rating: Double
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Method fetches similar movies from the current movie id
    var similar: [Self] { get async throws {
        let url = try NetworkService.buildURL(
            for: "/movie/\(id)/similar",
            relativeTo: NetworkService.baseURL
        )
        let movies: Movies = try await NetworkService.shared.loadData(from: url)
        await ImageCache.shared.loadImages(from: movies.results.map({ $0.posterURL }))
        return movies.results
    }}
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
    }
    
    /**
     A custom decoder that efficiently maps json response to respective Swift objects.
     This is done to reduce data transformation operations.
     */
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.rating = try container.decode(Double.self, forKey: .rating)
        
        // Extract year component from the release date received from the api response
        let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        if let releaseDate = Self.dateFormatter.date(from: releaseDateString) {
            self.releaseYear = Calendar.current.dateComponents([.year], from: releaseDate).year
        } else {
            self.releaseYear = nil
        }
        
        // Convert the poster path into Swift URL object pointing to the poster's image url
        let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        self.posterURL = try NetworkService.buildURL(for: posterPath, relativeTo: NetworkService.imageBaseURL)
    }
    
    /**
     A custom encoder to map `Movie` object to respective json data.
     */
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(overview, forKey: .overview)
        try container.encode(popularity, forKey: .popularity)
        try container.encode(rating, forKey: .rating)
        
        var dateComponents = DateComponents()
        dateComponents.year = releaseYear
        if let date = Calendar.current.date(from: dateComponents) {
            try container.encode(Self.dateFormatter.string(from: date), forKey: .releaseDate)
        }
        
        if let path = posterURL?.lastPathComponent {
            try container.encode(path, forKey: .posterPath)
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
