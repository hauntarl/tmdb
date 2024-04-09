//
//  BottomModalSheet.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//

import SwiftUI

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
        .background(.regularMaterial)
        .overlayPreferenceValue(CategoryPreferenceKey.self, buildOverlay(from:))
        .clipShape(SemiCircle(topInset: movie == .none ? availableHeight * 0.1 : .zero))
    }
    
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
        @Environment(\.animationDuration) var animationDuration
        @State private var selectedMovie: Movie?
        @State private var selectedCategory: BottomModalSheet.Category
        
        private let categories: [BottomModalSheet.Category] = [
            .init(icon: "house", highlighted: "house.fill"),
            .init(icon: "heart", highlighted: "heart.fill"),
            .init(icon: "magnifyingglass", highlighted: "sparkle.magnifyingglass")
        ]
        
        init() {
            _selectedCategory = .init(initialValue: categories[0])
        }
        
        var body: some View {
            GeometryReader { proxy in
                VStack {
                    Spacer()
                    
                    HStack {
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
