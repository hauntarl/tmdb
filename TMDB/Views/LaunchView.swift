//
//  LaunchView.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import Combine
import SwiftUI

struct LaunchView: View {
    static private let colors: [Color] = [
        .black,
        .logoPrimary,
        .logoSecondary,
        .logoTertiary,
    ]
    static private let delay = 0.5
    static private let totalDuration: Double = { delay * Double(colors.count) }()
    
    private let timer = Timer.publish(
        every: (Self.totalDuration - Self.delay) * 2,
        tolerance: Self.delay,
        on: .main,
        in: .common
    ).autoconnect()
    
    @Environment(\.animationDuration) var animationDuration
    @State private var gradientColors: [Color] = []
    @State private var scale = 1.0
    @State private var movies = [Movie]()
    
    var body: some View {
        if movies.isEmpty {
            loadingView
                .transition(.move(edge: .leading))
                .onDisappear(perform: cancelTimer)
        } else {
            MoviesView(movies: movies)
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
        .onReceive(timer) { _ in
            gradientTransition()
        }
        .onAppear {
            gradientTransition()
        }
        .task {
            await fetchMovies()
        }
    }
    
    private func fetchMovies() async {
        do {
            let nowPlaying = try await Movies.nowPlaying
            withAnimation(.bouncy(duration: animationDuration).delay(5)) {
                movies = nowPlaying
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /**
     Add colors to the gradient one at a time with increasing delay for each color.
     After all the colors are added, remove them one by one with increasing delay.
     */
    private func gradientTransition() {
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
