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
                selection: selectedCategory
            ) { category in
                withAnimation(.bouncy(duration: animationDuration)) {
                    selectedCategory = category
                    updateScrollTarget(movie: movies.first)
                }
            }
            .zIndex(1)
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
        
        withAnimation(.bouncy(duration: animationDuration)) {
            if isFavorite {
                // Add the selected movie to favorites
                favorites.insert(movie, at: .zero)
            } else {
                // Remove selected movie from favorites
                if let index = favorites.firstIndex(where: { $0 == movie }) {
                    favorites.remove(at: index)
                    if selectedCategory.name == .favorites {
                        updateScrollTarget(
                            movie: index == favorites.endIndex
                            ? favorites.last
                            : favorites[index]
                        )
                        selectedMovie = nil
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
        } catch {
            print("Couldn't fetch favorites: \(error.localizedDescription)")
        }
    }
}
