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
    @Binding var selection: Category

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
        .frame(height: movie == .none ? availableHeight * 0.2 : availableHeight * 0.6)
        .padding(.top, 50)
        .background(.ultraThickMaterial)
        // Displays a radial gradient behind currently selected category
        .overlayPreferenceValue(CategoryPreferenceKey.self, buildOverlay(from:))
        .clipShape(SemiCircle(topInset: movie == .none ? availableHeight * 0.1 : .zero))
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
                    ? category.highlighted
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
                    selection = category
                }
            }
        }
    }
}

#Preview {
    struct BottomModalSheetPreview: View {
        private let categories: [BottomModalSheet.Category] = [
            .init(icon: "house", highlighted: "house.fill"),
            .init(icon: "heart", highlighted: "heart.fill"),
            .init(icon: "magnifyingglass", highlighted: "sparkle.magnifyingglass")
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
                        selection: $selectedCategory
                            .animation(.bouncy(duration: animationDuration))
                    )
                }
                .ignoresSafeArea(edges: .bottom)
            }
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
