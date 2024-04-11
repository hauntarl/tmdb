//
//  MoviesView+Poster.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/10/24.
//

import SwiftUI

// MARK: Poster
extension MoviesView {
    @ViewBuilder
    func buildPoster(for movie: Movie, size: CGSize) -> some View {
        NetworkImage(url: movie.posterURL) { image in
            image
                .resizable()
                .scaledToFit()
                .transition(.opacity)
        } placeholder: {
            posterPlaceholder
                .transition(.opacity)
        }
        .frame(width: size.width, height: size.height, alignment: .top)
        .offset(y: selectedMovie == .none ? 50 : .zero)
        .scaleEffect(selectedMovie == .none ? 1.5 : 1)
        .blur(radius: selectedMovie == .none ? 5 : .zero)
        .clipped()
        .overlay {
            LinearGradient(
                colors: selectedMovie == .none ? [.logoPrimary, .clear] : [],
                startPoint: .bottom,
                endPoint: .top
            )
        }
        .id(movie.id)
        .contentTransition(.interpolate)
        .transition(.opacity)
    }
    
    var posterPlaceholder: some View {
        Image("Placeholder")
            .resizable()
            .scaledToFit()
            .hidden()
            .overlay {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
            }
    }
    
    var titleView: some View {
        Text(title)
            .font(.custom(Font.jostLight, size: 40))
            .shadow(color: .black, radius: 5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(x: 20, y: 75)
            .id(title)
            .transition(.blurReplace)
    }
    
    
    var hideDetailsButton: some View {
        Button {
            select(movie: nil)
        } label: {
            Image(systemName: "arrow.left")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background {
                    Capsule()
                        .foregroundStyle(.thinMaterial)
                }
        }
        .foregroundStyle(.primary)
        .position(x: 50, y: 100)
        .transition(.move(edge: .leading))
    }

    var title: String {
        if selectedCategory.name == .movies {
            return "Now playing"
        }
        return selectedCategory.name.rawValue
    }
    
    func updatePosterMovie(scrolledID: Int?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            if let scrolledID {
                posterMovie = nowPlaying.first { $0.id == scrolledID }
            } else {
                posterMovie = nil
            }
        }
    }
}
