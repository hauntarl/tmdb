//
//  SimilarMoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/11/24.
//

import SwiftUI

/**
 Fetches similar movies for the provided movie and displays it in a horizontal layout.
 
 - Parameters:
    - movie: The movie for which this view needs to look-up similar movies
    - itemWidth: Width for each similar movie card in the horizontal layout
    - leadingInset: The leading safe area padding for the horizontal layout
    - onSelect: A callback that accepts selected similar movie as a parameter
 */
struct SimilarMoviesView: View {
    @Environment(\.animationDuration) private var animationDuration
    @State private var similar: [Movie] = []
    let movie: Movie
    let itemWidth: Double
    let leadingInset: Double
    let onSelect: (Movie) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 15) {
                if similar.isEmpty {
                    ForEach(0..<3, id: \.self) { _ in
                        placeholder
                    }
                    .transition(.opacity)
                } else {
                    content
                        .transition(.opacity)
                }
            }
            .safeAreaPadding(.leading, leadingInset)
            .frame(height: itemWidth * 1.5)
        }
        .scrollIndicators(.never)
        .task { await fetchSimilar() }
    }
    
    var content: some View {
        ForEach(similar) { movie in
            NetworkImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: itemWidth)
                    .clipShape(.rect(cornerRadius: 20))
                    .transition(.opacity)
            } placeholder: {
                placeholder
                    .transition(.opacity)
            }
            .onTapGesture {
                onSelect(movie)
            }
        }
    }
    
    var placeholder: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.regularMaterial)
            .frame(width: itemWidth)
    }
    
    func fetchSimilar() async {
        do {
            let movies = try await movie.similar
            withAnimation(.bouncy(duration: animationDuration).delay(0.5)) {
                similar = movies
            }
        } catch {
            print("Error loading similar movies: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SimilarMoviesView(movie: Movie.sample, itemWidth: 150, leadingInset: 18) { movie in
        print("\(movie.title) selected.")
    }
    .animationDuration(1)
    .preferredColorScheme(.dark)
}
