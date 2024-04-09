//
//  LaunchView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Combine
import SwiftUI

/**
 `LaunchView` displays the launch screen for this app and loads `now playing` movies.
 Upon successful retrieval it display the `MoviesView` for the user to interact with
 fetched movies.
 */
struct LaunchView: View {
    static private let colors: [Color] = [
        .black,
        .logoPrimary,
        .logoSecondary,
        .logoTertiary,
    ]
    // Defines animation duration for the background linear gradient.
    static private let delay = 0.5
    // Calculates total animation duration based on the count of colors and delay.
    static private let totalDuration: Double = { delay * Double(colors.count) }()
    
    // The background linear gradient animation is re-invoked every time this timer
    // publishes a new value.
    private let timer = Timer.publish(
        every: (Self.totalDuration - Self.delay) * 2,
        tolerance: Self.delay,
        on: .main,
        in: .common
    ).autoconnect()
    
    @Environment(\.animationDuration) var animationDuration
    @State private var gradientColors: [Color] = []
    @State private var scale = 1.0
    @State private var nowPlaying = [Movie]()
    
    var body: some View {
        if nowPlaying.isEmpty {
            loadingView
        } else {
            MoviesView(movies: nowPlaying)
                .transition(.move(edge: .trailing))
        }
    }
    
    private var loadingView: some View {
        ZStack {
            LinearGradient(
                colors: gradientColors,
                startPoint: .leading,
                endPoint: .trailing
            )
            
            Rectangle()
                .foregroundStyle(.regularMaterial)
            
            Image("Logo")
                .scaleEffect(scale)
        }
        .ignoresSafeArea()
        .transition(.move(edge: .leading))
        .onReceive(timer) { _ in performAnimation() }
        .onAppear(perform: performAnimation)
        .task { await fetchMovies() }
        .onDisappear(perform: cancelTimer)
    }
    
    /**
     Fetches now playing movies from `Movies` aggregate model
     */
    private func fetchMovies() async {
        do {
            let movies = try await Movies.nowPlaying
            withAnimation(.bouncy(duration: animationDuration).delay(5)) {
                nowPlaying = movies
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /**
     Add colors to the gradient one at a time with increasing delay for each color.
     After all the colors are added, remove them one by one with increasing delay.
     */
    private func performAnimation() {
        // Add breathing effect to the TMDB logo
        withAnimation(
            .easeInOut(duration: Self.totalDuration - Self.delay)
            .repeatForever()
        ) {
            scale = 1.1
        }
        
        // Add colors to the gradient
        for index in 0..<Self.colors.count {
            withAnimation(
                .linear(duration: Self.totalDuration)
                .delay(Double(index) * Self.delay)
            ) {
                gradientColors.append(Self.colors[index])
            }
        }
        
        // Remove colors from the gradient
        for index in 0..<Self.colors.count {
            withAnimation(
                .linear(duration: Self.totalDuration)
                .delay(Self.totalDuration - Self.delay + Double(index) * Self.delay)
            ) {
                _ = gradientColors.removeFirst()
            }
        }
    }
    
    private func cancelTimer() {
        timer.upstream.connect().cancel()
    }
}

#Preview {
    LaunchView()
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
