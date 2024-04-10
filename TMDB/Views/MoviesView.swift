//
//  MoviesView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MoviesView: View {
    private let categories: [BottomModalSheet.Category] = [
        .init(icon: "house", highlighted: "house.fill"),
        .init(icon: "heart", highlighted: "heart.fill"),
        .init(icon: "magnifyingglass", highlighted: "sparkle.magnifyingglass")
    ]
    
    let nowPlaying: [Movie]

    @Environment(\.animationDuration) var animationDuration
    @State private var selectedMovie: Movie?
    @State private var selectedCategory: BottomModalSheet.Category
    @State private var scrolledID: Int?
    
    var spotlightMovie: Movie? {
        nowPlaying.first { $0.id == scrolledID }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                if let spotlightMovie {
                    buildPoster(
                        from: spotlightMovie.posterURL,
                        width: proxy.size.width
                    )
                    .zIndex(1.0)
                    
                    if selectedMovie != .none {
                        hideDetailsButton
                            .zIndex(2.0)
                    }
                }
                
                if selectedMovie == .none {
                    buildCarousel(size: proxy.size)
                        .zIndex(2.0)
                }
                
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
        .transition(.move(edge: .bottom))
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
    
    // MARK: Poster
    func buildPoster(from url: URL?, width: Double) -> some View {
        NetworkImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            posterPlaceholder
        }
        .frame(width: width)
        .clipped()
        .overlay {
            LinearGradient(
                colors: selectedMovie == .none ? [.logoPrimary, .clear] : [],
                startPoint: .bottom,
                endPoint: .top
            )
        }
        .scaleEffect(selectedMovie == .none ? 1.5 : 1)
        .blur(radius: selectedMovie == .none ? 5 : .zero)
        .contentTransition(.interpolate)
        .transition(.move(edge: .leading).combined(with: .move(edge: .top)))
        .animation(.bouncy(duration: animationDuration), value: url)
    }
    
    var posterPlaceholder: some View {
        Image("Placeholder")
            .resizable()
            .scaledToFit()
            .hidden()
            .overlay {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
                    .overlay {
                        Image("Logo")
                    }
            }
    }
    
    var hideDetailsButton: some View {
        Button {
            select(movie: nil)
            
        } label: {
            Image(systemName: "arrow.left")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.logoTertiary)
                .frame(width: 25, height: 25)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background {
                    Capsule()
                        .foregroundStyle(.ultraThickMaterial)
                }
        }
        .position(x: 50, y: 75)
        .transition(.move(edge: .leading))
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
        self._selectedCategory = .init(initialValue: categories[0])
        self._scrolledID = .init(initialValue: nowPlaying.first?.id)
    }

    func select(movie: Movie?) {
        withAnimation(.bouncy(duration: animationDuration)) {
            selectedMovie = movie
        }
    }
}

#Preview {
    MoviesView(nowPlaying: Movies.sample.results)
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
