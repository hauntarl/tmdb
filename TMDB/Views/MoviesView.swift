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
    
    @Environment(\.animationDuration) var animationDuration
    @State private var selectedMovie: Movie?
    @State private var selectedCategory: BottomModalSheet.Category

    let nowPlaying: [Movie]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let movie = selectedMovie {
                    buildPoster(from: movie.posterURL, proxy: proxy)
                } else {
                    content
                }
                
                buildBottomSheet(proxy: proxy)
                    .zIndex(2.0)
            }
            .ignoresSafeArea()
        }
    }
    
    // TODO: Replace list view with horizontal carousel
    var content: some View {
        List {
            ForEach(nowPlaying) { movie in
                HStack {
                    NetworkImage(url: movie.posterURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.regularMaterial)
                    }
                    .clipShape(.circle)
                    .frame(width: 40, height: 40)

                    Text(movie.title)
                }
                .onTapGesture {
                    selectMovie(movie: movie)
                }
            }
        }
        .transition(.blurReplace)
    }
    
    @ViewBuilder
    func buildPoster(from url: URL?, proxy: GeometryProxy) -> some View {
        NetworkImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .foregroundStyle(.logoPrimary)
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
        .clipped()
        .transition(.blurReplace)
        .ignoresSafeArea()
        
        Button {
            selectMovie(movie: nil)
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
    
    func buildBottomSheet(proxy: GeometryProxy) -> some View {
        VStack {
            Spacer()
            BottomModalSheet(
                movie: selectedMovie,
                availableHeight: proxy.size.height,
                categories: categories,
                selection: $selectedCategory.animation(.bouncy(duration: animationDuration))
            )
        }
    }
    
    init(nowPlaying: [Movie]) {
        self.nowPlaying = nowPlaying
        self._selectedCategory = .init(initialValue: categories[0])
    }

    func selectMovie(movie: Movie?) {
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
