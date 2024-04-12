//
//  BottomModalSheet.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//

import SwiftUI

/**
 A custom `TabView` implementation.
 
 - Parameters:
    - movie: If present, the `BottomModalSheet` behaves as a movie detail view
    - availableHeight: Used to calculate sheet height relative to this parameter
    - categories: All the categories that the user can browse through
    - selection: A value that represents user's currently selected category
 
 `BottomModalSheet` serves two purposes:
 - In contracted mode, it acts as a tab bar that lets user browse through different app
   categories
 - In expanded mode, it display the movie details for user selected movie
 */
struct BottomModalSheet: View {
    private let transition: AnyTransition = .move(edge: .bottom).combined(with: .opacity)
    
    @Environment(\.animationDuration) var animationDuration
    let movie: Movie?
    let availableHeight: Double
    let categories: [Category]
    let selection: Category
    let onTap: (Category) -> Void

    var body: some View {
        VStack {
            if let movie {
                MovieDetailView(movie: movie)
                    .transition(transition)
            } else {
                tabBar
                    .transition(transition)
            }
        }
        .frame(height: movie == .none ? availableHeight * 0.2 : nil)
        .padding(.top, movie == .none ? 50 : .zero)
        .background(.regularMaterial)
        // Displays a radial gradient behind currently selected category
        .overlayPreferenceValue(CategoryPreferenceKey.self, bottomModalSheetOverlay(from:))
        .clipShape(SemiCircle(radius: movie == .none ? availableHeight * 0.08 : .zero))
    }
    
    /**
     Displays all the categories in a horizontal layout, highlighting the currently selected
     category.
     */
    var tabBar: some View {
        HStack(spacing: .zero) {
            ForEach(categories) { category in
                Image(
                    systemName: selection == category
                    ? category.highlightedIcon
                    : category.icon
                )
                .resizable()
                .scaledToFit()
                .foregroundStyle(selection == category ? .logoSecondary : .secondary)
                .contentTransition(.symbolEffect)
                .frame(width: 35)
                .frame(maxWidth: .infinity)
                // Add this category's bounds to CategoryPreferenceKey
                .anchorPreference(key: CategoryPreferenceKey.self, value: .bounds) { anchor in
                    [CategoryPreference(category: category, anchor: anchor)]
                }
                .onTapGesture {
                    onTap(category)
                }
            }
        }
    }
}

#Preview {
    struct BottomModalSheetPreview: View {
        private let categories: [BottomModalSheet.Category] = [
            .init(name: .movies, icon: "house", highlightedIcon: "house.fill"),
            .init(name: .favorites, icon: "heart", highlightedIcon: "heart.fill"),
            .init(name: .search, icon: "magnifyingglass", highlightedIcon: "sparkle.magnifyingglass")
        ]

        @Environment(\.animationDuration) var animationDuration
        @State private var selectedMovie: Movie?
        @State private var selectedCategory: BottomModalSheet.Category
        
        var body: some View {
            GeometryReader { proxy in
                VStack(spacing: .zero) {
                    Spacer()
                    
                    HStack(spacing: 50) {
                        Button("Expand") {
                            selectMovie(movie: Movie.sample)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Contract") {
                            selectMovie(movie: nil)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Spacer()
                    
                    BottomModalSheet(
                        movie: selectedMovie,
                        availableHeight: proxy.size.height,
                        categories: categories,
                        selection: selectedCategory
                    ) { category in
                        withAnimation(.bouncy(duration: animationDuration)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        
        init() {
            _selectedCategory = .init(initialValue: categories[0])
        }
        
        func selectMovie(movie: Movie?) {
            withAnimation(.bouncy(duration: animationDuration)) {
                selectedMovie = movie
            }
        }
    }
    
    return BottomModalSheetPreview()
        .animationDuration(1)
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(.dark)
}
