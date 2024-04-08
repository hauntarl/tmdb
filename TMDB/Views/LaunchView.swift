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
        .init("LogoPrimary"),
        .init("LogoSecondary"),
        .init("LogoTertiary"),
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
    @State private var showingLoadingView = true
    
    var body: some View {
        if showingLoadingView {
            loadingView
                .transition(.move(edge: .leading))
        } else {
            MoviesView(movies: MovieResponse.sample.results)
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
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            gradientTransition()
        }
        .onAppear {
            gradientTransition()
            
            // TODO: Replace this code with fetch movies request
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.bouncy(duration: animationDuration)) {
                    showingLoadingView = false
                }
                cancelTimer()
            }
        }
    }
    
    /**
     Add colors to the gradient one at a time with increasing delay for each color.
     After all the colors are added, remove them one by one with increasing delay.
     */
    private func gradientTransition() {
        for index in 0..<Self.colors.count {
            withAnimation(
                .linear(duration: Self.totalDuration)
                .delay(Double(index) * Self.delay)
            ) {
                gradientColors.append(Self.colors[index])
            }
        }
        
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
        .animationDuration(0.5)
        .preferredColorScheme(.dark)
}
