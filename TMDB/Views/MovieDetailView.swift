//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

/**
 Displays details about the selected movie and also fetches similar movies.
 
 - Parameters:
    - movie: The movie for which the details need to be displayed
    - showSimilarMovies: Controls whether or not this view should display similar movies
 */
struct MovieDetailView: View {
    let movie: Movie
    var showSimilarMovies = true
    
    @Environment(\.animationDuration) private var animationDuration
    @State private var selectedSimilarMovie: Movie?
    @State private var showingSimilarMovies = false

    var body: some View {
        VStack(spacing: .zero) {
            content
            if showingSimilarMovies {
                similar
                    .transition(.move(edge: .trailing))
            }
        }
        .padding(.bottom, 30)
        .sheet(item: $selectedSimilarMovie) { movie in
            similarMovieDetails(for: movie)
        }
        .onAppear {
            withAnimation(.bouncy(duration: animationDuration)) {
                showingSimilarMovies = showSimilarMovies
            }
        }
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            title
            subtitle
            Spacer().frame(height: 20)
            
            Text(movie.overview)
                .font(.jostLight(size: 18))
                .foregroundStyle(.primary.opacity(0.8))
                .lineLimit(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if showSimilarMovies {
                Spacer().frame(height: 40)
                
                Text("More like this")
                    .font(.jostMedium(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 20)
            }
        }
        .padding([.horizontal, .top], 20)
    }
    
    var title: some View {
        (
            Text(movie.title)
                .font(.jostMedium(size: 26))
            + Text(year)
                .font(.jostMedium(size: 16))
                .foregroundStyle(.secondary)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var subtitle: some View {
        (
            Text(rating)
                .font(.jostMedium(size: 18))
            + Text(" / 10")
                .font(.jostMedium(size: 16))
                .foregroundStyle(.secondary)
            + Text("  ★")
                .font(.jostMedium(size: 16))
                .foregroundStyle(.yellow)
            + Text("  |  ")
                .font(.jostLight(size: 24))
            + Text(String(format: "%.1f", movie.popularity))
                .font(.jostMedium(size: 16))
                .foregroundStyle(.secondary)
            + Text("  🍿")
                .font(.jostMedium(size: 14))
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
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
