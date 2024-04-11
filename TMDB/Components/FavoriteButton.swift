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
    @Environment(\.animationDuration) var animationDuration
    @State private var isFavorite: Bool
    let colors: [Color]
    let size: Double
    let action: (Bool) -> Void
    
    var body: some View {
        Button {
            isFavorite.toggle()
            action(isFavorite)
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
    
    init(
        isFavorite: Bool = false,
        colors: [Color] = [.logoSecondary, .logoTertiary],
        size: Double = 30,
        action: @escaping (Bool) -> Void
    ) {
        self._isFavorite = .init(initialValue: isFavorite)
        self.colors = colors
        self.size = size
        self.action = action
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
        style: T = .logoSecondary,
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
                        
                        confettis(availableSize: proxy.size)
                    }
                    
                    content
                        .scaleEffect(contentScale)
                }
            )
            .padding(-10)
            .onAppear(perform: confettiTransition)
    }
    
    func confettis(availableSize: CGSize) -> some View {
        ForEach(0..<15) { i in
            Circle()
                .fill(confettiColors.randomElement() ?? .logoSecondary)
                .frame(
                    width: size + sin(Double(i)),
                    height: size + sin(Double(i))
                )
                .scaleEffect(confettiScale)
                .offset(
                    x: availableSize.width / 2 * confettiMovement
                    + (i.isMultiple(of: 2) ? size : .zero)
                )
                .rotationEffect(.degrees(24 * Double(i)))
                .offset(
                    x: (availableSize.width - size) / 2,
                    y: (availableSize.height - size) / 2
                )
                .opacity(confettiIsHidden ? 0 : 1)
        }
    }
    
    func confettiTransition() {
        withAnimation(.easeIn(duration: speed)) {
            circleSize = 1
        }
        withAnimation(.easeOut(duration: speed).delay(speed)) {
            strokeMultiplier = 0.00001
        }
        withAnimation(.interpolatingSpring(stiffness: 50, damping: 5).delay(speed)) {
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

#Preview {
    FavoriteButton(size: 60) {
        print("isFavorite? \($0)")
    }
    .animationDuration(1)
}
