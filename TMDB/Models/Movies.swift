//
//  Movies.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Foundation

/**
 `Movies` represents an aggregate model that responsible for providing movie results to the view
 from the [themoviedb.org](https://developer.themoviedb.org/reference/movie-now-playing-list) api.
 */
struct Movies: Decodable, Equatable {
    let results: [Movie]
}

/**
 `Movie` represents the internal structure of a `Movies` API response that is consumed by the view.
 
 It utilizes a custom decoding strategy in order to transform api response into fields
 that can be directly consumed by the views.
 */
struct Movie: Decodable, Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let popularity: Double
    let posterURL: URL?
    let releaseDate: Date?
    let rating: Double
    
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
     This is done to avoid creation of intermediate data models.
     */
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.rating = try container.decode(Double.self, forKey: .rating)
        
        // Convert the release date string into Swift Date object
        let releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.releaseDate = Self.dateFormatter.date(from: releaseDate)
        
        // Convert the poster path into Swift URL object pointing to the poster's image url
        let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        if let posterURL = URL(string: Self.posterBaseURL + posterPath) {
            self.posterURL = posterURL
        } else {
            self.posterURL = nil
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    private static let posterBaseURL: String = "https://image.tmdb.org/t/p/w500"
}
