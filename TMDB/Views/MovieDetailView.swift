//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    var showSimilarMovies = true
    
    @Environment(\.animationDuration) private var animationDuration
    @State private var selectedSimilarMovie: Movie?

    var body: some View {
        VStack(spacing: .zero) {
            content
            if showSimilarMovies {
                similar
            }
        }
        .padding(.bottom, 30)
        .sheet(item: $selectedSimilarMovie) { movie in
            similarMovieDetails(for: movie)
        }
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            title
            subtitle
            Spacer().frame(height: 20)
            
            Text(movie.overview)
                .font(.custom(Font.jostLight, size: 18))
                .foregroundStyle(.primary.opacity(0.8))
                .lineLimit(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if showSimilarMovies {
                Spacer().frame(height: 40)
                
                Text("More like this")
                    .font(.custom(Font.jostMedium, size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 20)
            }
        }
        .padding([.horizontal, .top], 20)
    }
    
    var title: some View {
        (
            Text(movie.title)
                .font(.custom(Font.jostMedium, size: 26))
            + Text(year)
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.secondary)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var subtitle: some View {
        (
            Text(rating)
                .font(.custom(Font.jostMedium, size: 18))
            + Text(" / 10")
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.secondary)
            + Text("  ★")
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.yellow)
            + Text("  |  ")
                .font(.custom(Font.jostLight, size: 24))
            + Text(String(format: "%.1f", movie.popularity))
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.secondary)
            + Text("  🍿")
                .font(.custom(Font.jostMedium, size: 14))
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var similar: some View {
        SimilarMoviesView(movie: movie, itemWidth: 150, leadingInset: 18) { movie in
            withAnimation(.bouncy(duration: animationDuration)) {
                selectedSimilarMovie = movie
            }
        }
        .id(movie.id)
        .ignoresSafeArea()
    }
    
    func similarMovieDetails(for movie: Movie) -> some View {
        ZStack {
            GeometryReader { proxy in
                NetworkImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.regularMaterial)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            
            VStack {
                Spacer()
                MovieDetailView(movie: movie, showSimilarMovies: false)
                    .background(.regularMaterial)
            }
        }
    }
    
    var year: String {
        guard let year = movie.releaseYear else {
            return ""
        }
        return "   \(year)"
    }
    
    var rating: String {
        String(format: "%.1f", movie.rating)
    }
}

#Preview {
    MovieDetailView(movie: .sample)
        .preferredColorScheme(.dark)
}
