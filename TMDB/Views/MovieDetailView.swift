//
//  MovieDetailView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        VStack(spacing: .zero) {
            content
            similar
        }
        .padding(.bottom, 30)
    }
    
    var content: some View {
        VStack(spacing: .zero) {
            title
            subtitle
            Spacer().frame(height: 20)
            
            Text(movie.overview)
                .font(.custom(Font.jostLight, size: 18))
                .foregroundStyle(.primary.opacity(0.8))
                .lineLimit(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 40)
            
            Text("More like this")
                .font(.custom(Font.jostMedium, size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 20)
        }
        .padding([.horizontal, .top], 20)
    }
    
    var title: some View {
        (
            Text(movie.title)
                .font(.custom(Font.jostMedium, size: 26))
            + Text(year)
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.secondary)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var subtitle: some View {
        (
            Text(rating)
                .font(.custom(Font.jostMedium, size: 18))
            + Text(" / 10")
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.secondary)
            + Text("  ★")
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.yellow)
            + Text("  |  ")
                .font(.custom(Font.jostLight, size: 24))
            + Text(String(format: "%.1f", movie.popularity))
                .font(.custom(Font.jostMedium, size: 16))
                .foregroundStyle(.secondary)
            + Text("  🍿")
                .font(.custom(Font.jostMedium, size: 14))
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // TODO: Fetch similar movies and display
    var similar: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.regularMaterial)
                    .frame(width: 150)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.regularMaterial)
                    .frame(width: 150)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.regularMaterial)
                    .frame(width: 150)
            }
            .safeAreaPadding(.leading, 18)
            .frame(height: 200)
        }
        .scrollIndicators(.never)
    }
    
    var year: String {
        guard let year = movie.releaseYear else {
            return ""
        }
        return "   \(year)"
    }
    
    var rating: String {
        String(format: "%.1f", movie.rating)
    }
}

#Preview {
    MovieDetailView(movie: .sample)
        .preferredColorScheme(.dark)
}
