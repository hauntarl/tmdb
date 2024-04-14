//
//  MoviesView+Categories.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/10/24.
//

import SwiftUI

// MARK: Categories
extension MoviesView {
    func buildBottomSheet(height: Double) -> some View {
        VStack {
            Spacer()
            
            if selectedMovie != .none {
                favoriteButton
                    .zIndex(2)
            }
            
            CategoriesView(
                selection: $selectedCategory.animation(.bouncy(duration: 0.5)),
                movie: selectedMovie,
                availableHeight: height,
                categories: Self.categories
            )
            .zIndex(1)
        }
    }
    
    func showDetails(for movie: Movie?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            selectedMovie = movie
        }
    }
    
    var favoriteButton: some View {
        let isFavorite = favorites.contains(where: { $0 == selectedMovie })
        
        return HStack {
            Spacer()
            FavoriteButton(isFavorite: isFavorite, size: 30, action: favoriteButtonAction)
                .foregroundStyle(.primary)
                .offset(x: -30, y: 30)
        }
        .id(selectedMovie?.id)
    }
    
    func favoriteButtonAction(_ isFavorite: Bool) {
        guard let movie = selectedMovie else {
            return
        }
        
        if isFavorite {
            // Add the selected movie to favorites
            favorites.insert(movie, at: .zero)
        } else {
            // Remove selected movie from favorites
            if let index = favorites.firstIndex(where: { $0 == movie }) {
                favorites.remove(at: index)
                
                // If current category is favorites, exit the movie detail view
                if selectedCategory.name == .favorites {
                    showDetails(for: nil)
                    
                    // Update poster to next movie, if the list is not empty
                    if let nextMovie = index == favorites.endIndex ? favorites.last : favorites[index] {
                        posterURL = nextMovie.posterURL
                    }
                }
            }
        }
        
        // Update persisting favorites data in background
        Task(priority: .background) {
            do {
                try Movies.save(favorites: favorites)
            } catch {
                print("Failed to save favorites: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFavorites() async {
        do {
            favorites = try await Movies.favorites
            
            // Update poster if current category is favorites
            if selectedCategory.name == .favorites {
                posterURL = favorites.first?.posterURL
            }
        } catch {
            print("Couldn't fetch favorites: \(error.localizedDescription)")
        }
    }
}
