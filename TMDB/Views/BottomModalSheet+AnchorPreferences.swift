//
//  BottomModalSheet+AnchorPreferences.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//

import SwiftUI

extension BottomModalSheet {
    func buildOverlay(from preferences: [CategoryPreference]) -> some View {
        movie == .none
        ? GeometryReader { proxy in
            if let selected = preferences.first(where: { $0.category == selection }) {
                let frame = proxy[selected.anchor]
                RadialGradient(
                    colors: [
                        .logoSecondary.opacity(0.100),
                        .logoTertiary.opacity(0.075),
                        .clear
                    ],
                    center: .center,
                    startRadius: .zero,
                    endRadius: 70
                )
                .position(x: frame.midX, y: frame.midY)
            }
        }
        .allowsHitTesting(false)
        : nil
    }
    
    struct Category: Identifiable, Equatable {
        var id: String { icon + highlighted }
        let icon: String
        let highlighted: String
    }
    
    struct CategoryPreference: Equatable {
        let category: Category
        let anchor: Anchor<CGRect>
    }
    
    struct CategoryPreferenceKey: PreferenceKey {
        static var defaultValue = [CategoryPreference]()
        
        static func reduce(value: inout [CategoryPreference], nextValue: () -> [CategoryPreference]) {
            value.append(contentsOf: nextValue())
        }
    }
}
