//
//  MoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MoviesView: View {
    let movies: [Movie]
    
    var body: some View {
        List(movies) { movie in
            Text(movie.title)
        }
    }
}

#Preview {
    MoviesView(movies: MovieResponse.sample.results)
        .preferredColorScheme(.dark)
}
