//
//  MoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MoviesView: View {
    private let categories: [BottomModalSheet.Category] = [
        .init(name: .movies, icon: "house", highlighted: "house.fill"),
        .init(name: .favorites, icon: "heart", highlighted: "heart.fill"),
        .init(name: .search, icon: "magnifyingglass", highlighted: "sparkle.magnifyingglass")
    ]
    
    let nowPlaying: [Movie]

    @Environment(\.animationDuration) var animationDuration
    @State var selectedMovie: Movie?
    @State var scrolledID: Int?
    @State var posterURL: URL?
    @State var selectedCategory: BottomModalSheet.Category
    @State var carouselOffsetY = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                if let posterURL {
                    buildPoster(
                        from: posterURL,
                        size: proxy.size
                    )
                    .zIndex(1.0)
                }
                
                if selectedMovie != .none {
                    hideDetailsButton
                        .zIndex(2.0)
                }
                
                if selectedMovie == .none {
                    titleView
                        .zIndex(2.0)
                }
                
                buildCarousel(size: proxy.size)
                    .zIndex(2.0)
                
                buildBottomSheet(height: proxy.size.height)
                    .zIndex(3.0)
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: Wheel Carousel
    func buildCarousel(size: CGSize) -> some View {
        WheelCarousel(
            items: nowPlaying,
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
                carouselPlaceholder(text: movie.title)
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
        .onChange(of: scrolledID) {
            updatePosterMovie(scrolledID: scrolledID)
        }
    }
    
    func carouselPlaceholder(text: String) -> some View {
        Image("Placeholder")
            .resizable()
            .scaledToFit()
            .hidden()
            .overlay {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
                    .overlay {
                        ProgressView()
                    }
            }
    }
    
    // MARK: BottomModalSheet
    func buildBottomSheet(height: Double) -> some View {
        VStack {
            Spacer()
            BottomModalSheet(
                movie: selectedMovie,
                availableHeight: height,
                categories: categories,
                selection: $selectedCategory.animation(.bouncy(duration: animationDuration))
            )
        }
    }
    
    // MARK: Methods
    init(nowPlaying: [Movie]) {
        self.nowPlaying = nowPlaying
        self._scrolledID = .init(initialValue: nowPlaying.first?.id)
        self._posterURL = .init(initialValue: nowPlaying.first?.posterURL)
        self._selectedCategory = .init(initialValue: categories[0])
    }

    func select(movie: Movie?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            if let selectedMovie {
                scrolledID = selectedMovie.id
                carouselOffsetY = 0
            } else if let movie {
                scrolledID = movie.id
                carouselOffsetY = 100
            }
            selectedMovie = movie
        }
    }
}

#Preview {
    MoviesView(nowPlaying: Movies.sample.results)
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
