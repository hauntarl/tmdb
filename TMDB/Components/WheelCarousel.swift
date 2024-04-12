//
//  WheelCarousel.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//

import SwiftUI

/**
 Creates a horizontal carousel where the leading and trailing views are rotated by the
 provided `rotation` amount, resulting in a wheel carousel.
 
 - Parameters:
    - items: The item structure used to build the carousel from
    - scrolledTo: The currently selected item in the wheel carousel
    - rotation: The angle in degrees that tilts the leading/trailing views
    - offsetY: The amount by which the leading/trailing views should be offset on the Y-axis
    - horizontalInset: Horizontal safe area inset amount
    - content: Returns a views based on the provided item from `items`
 */

struct WheelCarousel<Item: Equatable & Hashable, Content: View>: View {
    let items: [Item]
    @Binding var scrolledTo: Item?
    let rotation: Double
    let offsetY: Double
    let horizontalInset: Double
    @ViewBuilder let content: (Item) -> Content
        
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .scrollTransition { content, phase in
                            let (angle, anchor) = rotation(for: phase)
                            return content
                                .rotationEffect(angle, anchor: anchor)
                                .offset(y: phase.isIdentity ? .zero : offsetY)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrolledTo)
        .scrollBounceBehavior(.always, axes: .horizontal)
        .scrollIndicators(.never)
        .safeAreaPadding(.horizontal, horizontalInset)
    }
    
    func scrollButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .foregroundStyle(.regularMaterial)
        }
    }
    
    init(
        items: [Item],
        scrolledTo: Binding<Item?>,
        rotation: Double = 8,
        offsetY: Double = 30,
        horizontalInset: Double = 80,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self._scrolledTo = scrolledTo
        self.rotation = rotation
        self.offsetY = offsetY
        self.horizontalInset = horizontalInset
        self.content = content
    }
    
    func rotation(for phase: ScrollTransitionPhase) -> (Angle, UnitPoint) {
        switch phase {
        case .topLeading:
            (.degrees(-rotation), .bottomTrailing)
        case .identity:
            (.degrees(.zero), .center)
        case .bottomTrailing:
            (.degrees(rotation), .bottomLeading)
        }
    }
}

#Preview {
    struct WheelCarouselPreview: View {
        private let movies = Movies.sample.results
        @State private var scrolledTo: Movie?
        
        init() {
            self._scrolledTo = .init(initialValue: movies.first)
        }
        
        var body: some View {
            VStack {
                WheelCarousel(
                    items: movies,
                    scrolledTo: $scrolledTo,
                    horizontalInset: 82.5
                ) { movie in
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.regularMaterial)
                        .frame(width: 225, height: 350)
                        .overlay {
                            Text(movie.title)
                        }
                }
                
                HStack(spacing: 50) {
                    Button("First") {
                        scrolledTo = movies.first
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Last") {
                        scrolledTo = movies.last
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom, 30)
            }
            .onChange(of: scrolledTo, initial: true) {
                print(scrolledTo?.title ?? "nil")
            }
        }
    }
    
    return WheelCarouselPreview()
        .ignoresSafeArea()
        .animationDuration(1)
        .preferredColorScheme(.dark)
}
