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
                movie: selectedMovie,
                availableHeight: height,
                categories: categories,
                selection: selectedCategory
            ) { category in
                withAnimation(.bouncy(duration: animationDuration / 2)) {
                    selectedCategory = category
                }
                scrollTo(target: movies.first, delay: animationDuration * 0.51)
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
        
            if isFavorite {
                // Add the selected movie to favorites
                favorites.insert(movie, at: .zero)
            } else {
                // Remove selected movie from favorites
                if let index = favorites.firstIndex(where: { $0 == movie }) {
                    favorites.remove(at: index)
                    if selectedCategory.name == .favorites {
                        showDetails(for: nil)
                        scrollTo(
                            target: index == favorites.endIndex
                            ? favorites.last
                            : favorites[index],
                            delay: animationDuration * 0.51
                        )
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
