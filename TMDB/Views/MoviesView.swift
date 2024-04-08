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
            
            HStack {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(.circle)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 30, height: 30)
                
                Text(movie.title)
            }
        }
    }
}

#Preview {
    MoviesView(movies: Movies.sample.results)
        .preferredColorScheme(.dark)
}
