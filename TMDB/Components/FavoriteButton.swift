//
//  FavoriteButton.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/10/24.
//
//  Code snippet for CofettiModifier is inspired from ProSwiftUI book authored by
//  Paul Hudson.

import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    var colors: [Color] = [.logoSecondary, .logoTertiary]
    let size: Double
    
    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.linearGradient(
                        colors: colors,
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .transition(.confetti(
                        style: .radialGradient(
                            colors: colors,
                            center: .center,
                            startRadius: .zero,
                            endRadius: size * 0.75
                        ),
                        confettiColors: colors
                    ))
            } else {
                Image(systemName: "heart")
            }
        }
        .font(.system(size: size))
    }
}

extension AnyTransition {
    static var confetti: AnyTransition {
        .modifier(
            active: ConfettiModifier(style: .blue, confettiColors: [], size: 3),
            identity: ConfettiModifier(style: .blue, confettiColors: [], size: 3)
        )
    }
    
    static func confetti<T: ShapeStyle>(
        style: T = .blue,
        confettiColors: [Color] = [],
        size: Double = 3
    ) -> AnyTransition {
        .modifier(
            active: ConfettiModifier(
                style: style,
                confettiColors: confettiColors,
                size: size
            ),
            identity: ConfettiModifier(
                style: style,
                confettiColors: confettiColors,
                size: size
            )
        )
    }
}

struct ConfettiModifier<T: ShapeStyle>: ViewModifier {
    
    var style: T
    var confettiColors: [Color]
    var size: Double
    var speed: TimeInterval = 0.3
    
    @State private var circleSize = 0.00001
    @State private var strokeMultiplier = 1.0
    
    @State private var confettiIsHidden = true
    @State private var confettiMovement = 0.7
    @State private var confettiScale = 1.0
    
    @State private var contentScale = 0.00001
    
    
    func body(content: Content) -> some View {
        content
            .hidden()
            .padding(10)
            .overlay(
                ZStack {
                    GeometryReader { proxy in
                        Circle()
                            .strokeBorder(
                                style,
                                lineWidth: proxy.size.width / 2 * strokeMultiplier
                            )
                            .scaleEffect(circleSize)
                        
                        ForEach(0..<15) { i in
                            Circle()
                                .fill(confettiColors.randomElement() ?? .logoSecondary)
                                .frame(
                                    width: size + sin(Double(i)),
                                    height: size + sin(Double(i))
                                )
                                .scaleEffect(confettiScale)
                                .offset(
                                    x: proxy.size.width / 2 * confettiMovement 
                                    + (i.isMultiple(of: 2) ? size : .zero)
                                )
                                .rotationEffect(.degrees(24 * Double(i)))
                                .offset(
                                    x: (proxy.size.width - size) / 2,
                                    y: (proxy.size.height - size) / 2
                                )
                                .opacity(confettiIsHidden ? 0 : 1)
                        }
                    }
                    
                    content
                        .scaleEffect(contentScale)
                }
            )
            .padding(-10)
            .onAppear {
                withAnimation(.easeIn(duration: speed)) {
                    circleSize = 1
                }
                withAnimation(.easeOut(duration: speed).delay(speed)) {
                    strokeMultiplier = 0.00001
                }
                withAnimation(
                    .interpolatingSpring(stiffness: 50, damping: 5).delay(speed)
                ) {
                    contentScale = 1
                }
                withAnimation(.easeOut(duration: speed).delay(speed * 1.25)) {
                    confettiIsHidden = false
                    confettiMovement = 1.2
                }
                withAnimation(.easeOut(duration: speed).delay(speed * 2)) {
                    confettiScale = 0.00001
                }
            }
    }
}

#Preview {
    struct FavoriteButtonPreview: View {
        @State private var isFavorite = false
        
        var body: some View {
            FavoriteButton(isFavorite: $isFavorite, size: 60)
        }
    }
    
    return FavoriteButtonPreview()
        .animationDuration(1)
}
