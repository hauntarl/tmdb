//
//  AnimationDurationKey.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

/**
 To control the duration for every common animation and transition throughout the app
 */
struct AnimationDurationKey: EnvironmentKey {
    static var defaultValue = 0.3
}

extension EnvironmentValues {
    public var animationDuration: Double {
        get { self[AnimationDurationKey.self] }
        set { self[AnimationDurationKey.self] = newValue }
    }
}

extension View {
    @inlinable func animationDuration(_ duration: Double = 0.3) -> some View {
        environment(\.animationDuration, duration)
    }
}
