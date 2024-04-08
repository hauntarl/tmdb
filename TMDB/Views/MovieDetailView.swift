//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        Text(movie.title)
    }
}

#Preview {
    MovieDetailView(movie: .sample)
        .preferredColorScheme(.dark)
}
