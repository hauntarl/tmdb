//
//  MoviesView+BottomModalSheet.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/10/24.
//

import SwiftUI

// MARK: BottomModalSheet
extension MoviesView {
    func buildBottomSheet(height: Double) -> some View {
        VStack {
            Spacer()
            
            if selectedMovie != .none {
                favoriteButton
                    .zIndex(2)
            }
            
            BottomModalSheet(
                movie: selectedMovie,
                availableHeight: height,
                categories: categories,
                selection: $selectedCategory.animation(.bouncy(duration: animationDuration))
            )
            .onChange(of: selectedCategory) {
                withAnimation(.bouncy(duration: animationDuration)) {
                    switch selectedCategory.name {
                    case .movies:
                        movies = nowPlaying
                    case .favorites:
                        movies = favorites.values.sorted { $0.title < $1.title }
                    case .search:
                        movies = []
                        break
                    }
                    
                    scrolledID = movies.first?.id
                    posterMovie = movies.first
                }
            }

            .zIndex(1)
        }
    }
    
    var favoriteButton: some View {
        HStack {
            Spacer()
            FavoriteButton(
                isFavorite: favorites[selectedMovie?.id ?? .zero] != nil,
                size: 30,
                action: favoriteButtonAction
            )
            .foregroundStyle(.primary)
            .padding(10)
            .background(favoriteButtonBackground)
            .offset(x: -30, y: 30)
        }
        .id(selectedMovie?.id)
        .animation(.bouncy(duration: animationDuration), value: favorites[selectedMovie?.id ?? .zero])
    }
    
    var favoriteButtonBackground: some View {
        Circle()
            .foregroundStyle(.ultraThinMaterial)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(
                        .linearGradient(
                            colors: favorites[selectedMovie?.id ?? .zero] != nil
                            ? [.logoSecondary, .logoTertiary]
                            : [.primary],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
    }
    
    func favoriteButtonAction(_ isFavorite: Bool) {
        guard let movie = selectedMovie else {
            return
        }
        
        if isFavorite {
            // Add the selected movie to favorites
            favorites[movie.id] = movie
        } else {
            // Remove selected movie from favorites
            favorites.removeValue(forKey: movie.id)
            if selectedCategory.name == .favorites, let index = movies.firstIndex(of: movie) {
                movies.remove(at: index)
                withAnimation(.bouncy(duration: animationDuration)) {
                    let nextIndex = index < movies.endIndex ? index : movies.endIndex - 1
                    updateCarouselState(using: nextIndex > -1 ? movies[nextIndex].id : nil, showingCarousel: true)
                    selectedMovie = nil
                }
            }
        }
        
        // Update persisting favorites data in background
        Task(priority: .background) {
            do {
                try Movies.save(favorites: Array(favorites.values))
            } catch {
                print("Failed to save favorites: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFavorites() async {
        do {
            favorites = try await Movies.favorites
        } catch {
            print("Couldn't fetch favorites: \(error.localizedDescription)")
        }
    }
}
