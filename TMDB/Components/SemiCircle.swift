//
//  SemiCircle.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//

import SwiftUI

/**
 Animatable semi-circle shape that is used as clip shape for `BottomModalSheet`
 */
struct SemiCircle: Shape, Animatable {
    var topInset: Double
    
    var animatableData: Double {
        get { topInset }
        set { topInset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: .zero, y: topInset))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: topInset),
            control: CGPoint(x: rect.width * 0.5, y: .zero)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: .zero, y: rect.height))
        return path
    }
}

#Preview {
    SemiCircle(topInset: 50)
        .foregroundStyle(.regularMaterial)
        .frame(height: 200)
        .preferredColorScheme(.dark)
}
