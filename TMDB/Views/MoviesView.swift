//
//  MoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MoviesView: View {
    let movies: [Movie]
    let errorMessage: LocalizedStringKey?
    
    var body: some View {
        List {
            if let errorMessage {
                Text(errorMessage)
            }
            
            ForEach(movies) { movie in
                Text(movie.title)
            }
        }
    }
}

#Preview {
    MoviesView(movies: Movies.sample.results, errorMessage: nil)
        .preferredColorScheme(.dark)
}
