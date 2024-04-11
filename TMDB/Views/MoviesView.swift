//
//  MoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MoviesView: View {
    let categories: [BottomModalSheet.Category] = [
        .init(name: .movies, icon: "house", highlightedIcon: "house.fill"),
        .init(name: .favorites, icon: "heart", highlightedIcon: "heart.fill"),
        .init(name: .search, icon: "magnifyingglass", highlightedIcon: "sparkle.magnifyingglass")
    ]

    @Environment(\.animationDuration) var animationDuration
    
    let nowPlaying: [Movie]
    @State var favorites = [Int: Movie]()
    @State var movies: [Movie]

    @State var selectedMovie: Movie?
    @State var scrolledID: Int?
    @State var posterMovie: Movie?
    @State var carouselOffsetY = 0.0
    
    @State var selectedCategory: BottomModalSheet.Category

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                if let posterMovie {
                    buildPoster(for: posterMovie, size: proxy.size)
                        .zIndex(1.0)
                }
                
                if movies.isEmpty {
                    contentUnavailable(size: proxy.size)
                        .zIndex(0.0)
                }
                
                buildCarousel(size: proxy.size)
                    .zIndex(2.0)
                
                if selectedMovie != .none {
                    hideDetailsButton
                        .zIndex(2.0)
                } else {
                    titleView
                        .zIndex(2.0)
                }
                
                buildBottomSheet(height: proxy.size.height)
                    .zIndex(3.0)
            }
            .task {
                await fetchFavorites()
            }
        }
        .ignoresSafeArea()
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
            }
        }
        .safeAreaPadding(.top, 80)
        .offset(y: carouselOffsetY)
        .transition(.move(edge: .bottom))
        .allowsHitTesting(selectedMovie == nil)
        .onChange(of: scrolledID) {
            updatePosterMovie(scrolledID: scrolledID)
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
    
    func contentUnavailable(size: CGSize) -> some View {
        ContentUnavailableView(
            "Nothing to see here ツ",
            image: "Logo",
            description: Text(contentUnavailableDescription)
        )
        .background {
            Image("Placeholder")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.5)
                .frame(width: size.width, height: size.height, alignment: .top)
                .blur(radius: 20)
                .opacity(0.4)
        }
        .clipped()
        .transition(.opacity)
    }
    
    var contentUnavailableDescription: LocalizedStringKey {
        switch selectedCategory.name {
        case .movies:
            return "Movies not available at the moment. Please try again later."
        case .favorites:
            return "You do not have any **\(selectedCategory.name.rawValue)**. Start marking some movies as favorites to see them here!"
        default:
            return "Not yet implemented"
        }
    }

    // MARK: Methods
    init(nowPlaying: [Movie]) {
        self.nowPlaying = nowPlaying
        self._movies = .init(initialValue: nowPlaying)
        self._scrolledID = .init(initialValue: nowPlaying.first?.id)
        self._posterMovie = .init(initialValue: nowPlaying.first)
        self._selectedCategory = .init(initialValue: categories[0])
    }

    func select(movie: Movie?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            if let selectedMovie {
                // transition from movie details view to tab bar view
                updateCarouselState(using: selectedMovie.id, showingCarousel: true)
            } else if let movie {
                // transition from tab bar view to movie details view
                updateCarouselState(using: movie.id, showingCarousel: false)
            }
            selectedMovie = movie
        }
    }
    
    func updateCarouselState(using newID: Int?, showingCarousel: Bool) {
        scrolledID = newID
        carouselOffsetY = showingCarousel ? 0 : 100
    }
}

#Preview {
    MoviesView(nowPlaying: Movies.sample.results)
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
