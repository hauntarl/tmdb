//
//  MoviesView+SearchCategory.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/11/24.
//

import SwiftUI

extension MoviesView {
    // MARK: Search Category
    var searchBar: some View {
        HStack {
            Image(systemName: BottomModalSheet.CategoryName.search.rawValue)
                .font(.system(size: 20))
                .foregroundStyle(.logoTertiary)
            
            TextField("Start typing here...", text: $searchText.animation())
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
    }
    
    // MARK: Content unavailable view
    func contentUnavailable(size: CGSize) -> some View {
        ContentUnavailableView(
            contentUnavailableTitle,
            image: "Logo",
            description: Text(contentUnavailableDescription)
        )
        .background {
            Image("Placeholder")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.5)
                .blur(radius: 20)
                .opacity(0.3)
        }
        .frame(width: size.width, height: size.height, alignment: .top)
        .clipped()
        .offset(y: -keyboardHeight * 0.2)
        .contentTransition(.interpolate)
        .transition(.opacity)
    }
    
    var contentUnavailableTitle: String {
        if selectedCategory.name == .search {
            if searchText.isEmpty {
                return "Find movies..."
            } else if !noSearchResults {
                return "Searching TheMovieDB..."
            }
        }
        return "Nothing to see here ツ"
    }
    
    var contentUnavailableDescription: LocalizedStringKey {
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
}
