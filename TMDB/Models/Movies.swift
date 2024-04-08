//
//  Movies.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Foundation

/**
 `Movies` represents an aggregate model that is responsible for providing movie results
 like **now playing, popular, top-rated, and upcoming** from the
 [themoviedb.org](https://developer.themoviedb.org/reference/intro/getting-started) api.
 */
struct Movies: Decodable, Equatable {
    let results: [Movie]
    
    // Factory method that fetches now playing movies
    static var nowPlaying: [Movie] { get async throws {
        guard var url = URL(string: "now_playing", relativeTo: NetworkService.baseURL) else {
            throw NetworkError.badURL(message: "Cannot fetch **Now Playing Movies**: Bad URL")
        }
        let params = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "api_key", value: "api_key")
        ]
        url.append(queryItems: params)
        
        let movies: Self = try await NetworkService.shared.loadData(from: url)
        return movies.results.filter { $0.posterURL != nil }
    }}
}

/**
 `Movie` represents the internal structure of a `Movies` aggregate model that is consumed by the view.
 It also provides a method to fetch movies similar to the current movie as it directly depends
 on the `id` attribute of a movie.
 
 It utilizes a custom decoding strategy in order to transform api response into fields
 that can be directly consumed by the views.
 */
struct Movie: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let posterURL: URL?
    let releaseYear: Int?
    let rating: Double
    
    // Method fetches similar movies from the current movie id
    var similar: [Self] { get async throws {
        guard var url = URL(string: "\(id)/similar", relativeTo: NetworkService.baseURL) else {
            throw NetworkError.badURL(message: "Cannot fetch **Similar Movies** at the time :(")
        }
        let params = [URLQueryItem(name: "api_key", value: "api_key")]
        url.append(queryItems: params)
        
        let movies: [Movie] = try await NetworkService.shared.loadData(from: url)
        return movies.filter { $0.posterURL != nil }
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
     This is done to reduce data transformation operations at the aggregate model level.
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
        self.posterURL = URL(string: posterPath, relativeTo: NetworkService.posterBaseURL)
    }
    
    // posterBaseURL is used to convert poster path to an url pointing towards the image.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
