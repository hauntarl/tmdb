//
//  Samples.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Foundation

extension Movies {
    /**
     Sample `Movies` used for previews and testing
     */
    static let sample: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleJSON)
    }()
    
    static let sampleJSON = """
    {
         "results": [
             {
                 "adult": false,
                 "backdrop_path": "/sR0SpCrXamlIkYMdfz83sFn5JS6.jpg",
                 "genre_ids": [
                     28,
                     878,
                     12,
                     14
                 ],
                 "id": 823464,
                 "original_language": "en",
                 "original_title": "Godzilla x Kong: The New Empire",
                 "overview": "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
                 "popularity": 3537.982,
                 "poster_path": "/1hUTqPnfTvuupk7XW7WCkWYW4M1.jpg",
                 "release_date": "2024-03-27",
                 "title": "Godzilla x Kong: The New Empire",
                 "video": false,
                 "vote_average": 6.7,
                 "vote_count": 462
             },
             {
                 "adult": false,
                 "backdrop_path": "/1XDDXPXGiI8id7MrUxK36ke7gkX.jpg",
                 "genre_ids": [
                     28,
                     12,
                     16,
                     35,
                     10751
                 ],
                 "id": 1011985,
                 "original_language": "en",
                 "original_title": "Kung Fu Panda 4",
                 "overview": "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.",
                 "popularity": 2397.553,
                 "poster_path": "/kDp1vUBnMpe8ak4rjgl3cLELqjU.jpg",
                 "release_date": "2024-03-02",
                 "title": "Kung Fu Panda 4",
                 "video": false,
                 "vote_average": 6.735,
                 "vote_count": 617
             },
             {
                 "adult": false,
                 "backdrop_path": "/oe7mWkvYhK4PLRNAVSvonzyUXNy.jpg",
                 "genre_ids": [
                     28,
                     53
                 ],
                 "id": 359410,
                 "original_language": "en",
                 "original_title": "Road House",
                 "overview": "Ex-UFC fighter Dalton takes a job as a bouncer at a Florida Keys roadhouse, only to discover that this paradise is not all it seems.",
                 "popularity": 1899.222,
                 "poster_path": "/bXi6IQiQDHD00JFio5ZSZOeRSBh.jpg",
                 "release_date": "2024-03-08",
                 "title": "Road House",
                 "video": false,
                 "vote_average": 7.122,
                 "vote_count": 1243
             },
             {
                 "adult": false,
                 "backdrop_path": "/pwGmXVKUgKN13psUjlhC9zBcq1o.jpg",
                 "genre_ids": [
                     28,
                     14
                 ],
                 "id": 634492,
                 "original_language": "en",
                 "original_title": "Madame Web",
                 "overview": "Forced to confront revelations about her past, paramedic Cassandra Webb forges a relationship with three young women destined for powerful futures...if they can all survive a deadly present.",
                 "popularity": 1295.325,
                 "poster_path": "/rULWuutDcN5NvtiZi4FRPzRYWSh.jpg",
                 "release_date": "2024-02-14",
                 "title": "Madame Web",
                 "video": false,
                 "vote_average": 5.657,
                 "vote_count": 984
             },
             {
                 "adult": false,
                 "backdrop_path": "/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg",
                 "genre_ids": [
                     878,
                     12
                 ],
                 "id": 693134,
                 "original_language": "en",
                 "original_title": "Dune: Part Two",
                 "overview": "Follow the mythic journey of Paul Atreides as he unites with Chani and the Fremen while on a path of revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the known universe, Paul endeavors to prevent a terrible future only he can foresee.",
                 "popularity": 986.406,
                 "poster_path": "/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg",
                 "release_date": "2024-02-27",
                 "title": "Dune: Part Two",
                 "video": false,
                 "vote_average": 8.4,
                 "vote_count": 2480
             }
         ]
    }
    """.data(using: .utf8)!
}

extension Movie {
    /**
     Sample `Movie` used for previews and testing
     */
    static let sample: Self = {
        try! JSONDecoder().decode(Self.self, from: sampleJSON)
    }()
    
    static let sampleJSON = """
    {
         "id": 823464,
         "original_title": "Godzilla x Kong: The New Empire",
         "overview": "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
         "popularity": 3537.982,
         "poster_path": "/1hUTqPnfTvuupk7XW7WCkWYW4M1.jpg",
         "release_date": "2024-03-27",
         "title": "Godzilla x Kong: The New Empire",
         "vote_average": 6.7,
    }
    """.data(using: .utf8)!
}
