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
        List {
            ForEach(movies) { movie in
                HStack {
                    NetworkImage(url: movie.posterURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.regularMaterial)
                    }
                    .clipShape(.circle)
                    .frame(width: 40, height: 40)

                    Text(movie.title)
                }
            }
        }
    }
}

#Preview {
    MoviesView(movies: Movies.sample.results)
        .preferredColorScheme(.dark)
}
