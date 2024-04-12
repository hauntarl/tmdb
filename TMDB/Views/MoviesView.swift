//
//  MoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

/**
 MoviesView is the home screen of this application, it displays a tab bar at the bottom that
 allows users to hop between different categories. It also displays the content for each tab
 category.
 
 - Parameters:
    - nowPlaying: By default `MoviesView` displays now playing movies
 */
struct MoviesView: View {
    let categories: [CategoriesView.Category] = [
        .init(name: .movies, icon: "house", highlightedIcon: "house.fill"),
        .init(name: .favorites, icon: "heart", highlightedIcon: "heart.fill"),
        .init(name: .search, icon: "magnifyingglass", highlightedIcon: "sparkle.magnifyingglass")
    ]

    let nowPlaying: [Movie]

    @Environment(\.animationDuration) var animationDuration
    @State var favorites = [Movie]()
    @State var selectedCategory: CategoriesView.Category
    @State var scrolledTo: Movie?
    @State var selectedMovie: Movie?
    
    @FocusState var searchFocus
    @StateObject var searchText = Debouncer(initialValue: "", delay: 1)
    @State var searchResults = [Movie]()
    @State var noSearchResults = false
    @State var keyboardHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
                
                buildCarousel(size: proxy.size)
                    .zIndex(1)
                
                if movies.isEmpty {
                    contentUnavailable(size: proxy.size)
                        .zIndex(2)
                }
                
                if selectedMovie == .none {
                    titleView
                        .zIndex(3)
                    
                    if selectedCategory.name == .search {
                        searchBar
                            .zIndex(3)
                    }
                } else {
                    hideDetailsButton
                        .zIndex(3)
                }
                
                buildBottomSheet(height: proxy.size.height)
                    .zIndex(3)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .keyboardHeightListener(
            value: $keyboardHeight.animation(.bouncy(duration: animationDuration))
        )
        .ignoresSafeArea()
        .task {
            await fetchFavorites()
        }
        .onAppear {
            scrolledTo = movies.first
        }
    }
    
    // MARK: Wheel Carousel
    func buildCarousel(size: CGSize) -> some View {
        WheelCarousel(
            items: movies,
            scrolledTo: $scrolledTo,
            rotation: 10,
            offsetY: 20,
            horizontalInset: size.width / 4
        ) { movie in
            NetworkImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                carouselPlaceholder
            }
            .frame(width: size.width / 2)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(radius: 10)
            .onTapGesture {
                showDetails(for: movie)
                searchFocus = false
            }
        }
        .safeAreaPadding(.top, 80)
        .safeAreaPadding(.bottom, keyboardHeight * 0.6)
        .offset(y: selectedMovie == nil ? 0 : 100)
        .allowsHitTesting(selectedMovie == nil)
        .background {
            buildPoster(of: size)
        }
    }
    
    var carouselPlaceholder: some View {
        Image("Placeholder")
            .resizable()
            .scaledToFit()
            .hidden()
            .overlay {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
            }
    }
    
    var movies: [Movie] {
        switch selectedCategory.name {
        case .movies:
            return nowPlaying
        case .favorites:
            return favorites
        case .search:
            return searchResults
        }
    }
    
    func showDetails(for movie: Movie?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            selectedMovie = movie
        }
        scrollTo(target: movie, delay: animationDuration * 0.51)
    }
    
    func scrollTo(target: Movie?, delay: TimeInterval) {
        if let target {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.bouncy(duration: animationDuration)) {
                    scrolledTo = target
                }
            }
        }
    }

    init(nowPlaying: [Movie]) {
        self.nowPlaying = nowPlaying
        self._selectedCategory = .init(initialValue: categories.first!)
    }
}

#Preview {
    MoviesView(nowPlaying: Movies.sample.results)
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
