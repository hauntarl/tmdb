//
//  MoviesView+Search.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/11/24.
//

import SwiftUI

extension MoviesView {
    // MARK: Search
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundStyle(.logoTertiary)
            
            TextField("Start typing here...", text: $searchText.input)
                .font(.custom(Font.jostLight, size: 20))
                .autocorrectionDisabled()
                .focused($searchFocus)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.regularMaterial)
                .shadow(radius: 10)
        }
        .padding()
        .offset(y: 125)
        .transition(.move(edge: .trailing))
        .onChange(of: searchText.output) { _, newValue in
            searchMovies(query: newValue)
        }
    }
    
    // MARK: Content unavailable view
    func contentUnavailable(size: CGSize) -> some View {
        ContentUnavailableView(
            contentUnavailableTitle,
            image: "Logo",
            description: Text(contentUnavailableDescription)
        )
        .background(.thinMaterial)
        .frame(width: size.width, height: size.height, alignment: .top)
        .clipped()
        .offset(y: -keyboardHeight * 0.2)
        .contentTransition(.interpolate)
        .transition(.opacity)
        .animation(.bouncy(duration: animationDuration), value: searchText.output)
    }
    
    var contentUnavailableTitle: String {
        if selectedCategory.name == .search {
            if searchText.output.isEmpty {
                return "Find movies..."
            } else if !noSearchResults {
                return "Searching database..."
            }
        }
        return "Nothing to see here ツ"
    }
    
    var contentUnavailableDescription: LocalizedStringKey {
        let searchText = searchText.output
        switch selectedCategory.name {
        case .movies:
            return "**[\(selectedCategory.name.rawValue)](nowPlaying)** not available at the moment. Please try again later."
        case .favorites:
            return "You do not have any **[\(selectedCategory.name.rawValue)](favorites)**. Start marking some movies as favorites to see them here!"
        case .search:
            if searchText.isEmpty {
                return "You can search movies by typing keywords in the **[Search bar](\(searchText))** at the top."
            } else if noSearchResults {
                return "Couldn't find any movies for\n**[\(searchText)](\(searchText))**."
            } else {
                return "For movies matching **[\(searchText)](\(searchText))**"
            }
        }
    }
    
    /**
     Fetches search result movies from `Movies` aggregate model
     */
    func searchMovies(query: String) {
        Task {
            do {
                let movies = try await Movies.search(query: query)
                withAnimation(.bouncy(duration: animationDuration)) {
                    searchResults = movies
                }
                scrollTo(target: movies.first, delay: animationDuration * 0.51)
            } catch {
                print("Error occurred while searching: \(error.localizedDescription)")
            }
        }
    }
}
