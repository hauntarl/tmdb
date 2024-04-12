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
    let categories: [BottomModalSheet.Category] = [
        .init(name: .movies, icon: "house", highlightedIcon: "house.fill"),
        .init(name: .favorites, icon: "heart", highlightedIcon: "heart.fill"),
        .init(name: .search, icon: "magnifyingglass", highlightedIcon: "sparkle.magnifyingglass")
    ]

    let nowPlaying: [Movie]
    @State var movies: [Movie]
    @State var scrolledID: Int?
    @State var posterMovie: Movie?
    @State var selectedCategory: BottomModalSheet.Category

    @Environment(\.animationDuration) var animationDuration
    @State var favorites = [Int: Movie]()
    @State var selectedMovie: Movie?
    @State var carouselOffsetY = 0.0
    
    @FocusState var searchFocus
    @State var searchText = ""
    @State var noSearchResults = false
    @State var keyboardHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                if movies.isEmpty {
                    contentUnavailable(size: proxy.size)
                        .zIndex(0)
                }
                
                if let posterMovie {
                    buildPoster(for: posterMovie, size: proxy.size)
                        .zIndex(1)
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
                
                buildCarousel(size: proxy.size)
                    .zIndex(2)

                buildBottomSheet(height: proxy.size.height)
                    .zIndex(3)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .keyboardHeightListener(
            value: $keyboardHeight.animation(.bouncy(duration: animationDuration))
        )
        .ignoresSafeArea()
        .task {
            await fetchFavorites()
        }
        .onChange(of: selectedCategory) { _, newValue in
            updateMovies(category: newValue)
        }
        .onChange(of: scrolledID) { _, newValue in
            updatePosterMovie(scrolledID: newValue)
        }
    }
    
    // MARK: Wheel Carousel
    func buildCarousel(size: CGSize) -> some View {
        WheelCarousel(
            items: movies,
            scrolledID: $scrolledID,
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
                select(movie: movie)
                searchFocus = false
            }
        }
        .safeAreaPadding(.top, 80)
        .safeAreaPadding(.bottom, keyboardHeight * 0.6)
        .offset(y: carouselOffsetY)
        .allowsHitTesting(selectedMovie == nil)
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
    
    func select(movie: Movie?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            if let selectedMovie {
                // transition from movie details view to tab bar view
                updateCarousel(using: selectedMovie.id, carouselHighlighted: true)
            } else if let movie {
                // transition from tab bar view to movie details view
                updateCarousel(using: movie.id, carouselHighlighted: false)
            }
            selectedMovie = movie
        }
    }
    
    func updateCarousel(using newID: Int?, carouselHighlighted: Bool) {
        scrolledID = newID
        carouselOffsetY = carouselHighlighted ? .zero : 100
    }

    init(nowPlaying: [Movie]) {
        self.nowPlaying = nowPlaying
        self._movies = .init(initialValue: nowPlaying)
        self._scrolledID = .init(initialValue: nowPlaying.first?.id)
        self._posterMovie = .init(initialValue: nowPlaying.first)
        self._selectedCategory = .init(initialValue: categories.first!)
    }
}

#Preview {
    MoviesView(nowPlaying: Movies.sample.results)
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
