//
//  SemiCircle.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/9/24.
//

import SwiftUI

/**
 Animatable semi-circle shape that is used as clip shape for `CategoriesView`
 
 - Parameters:
    - radius: Controls the curve of this semi-circle
 */
struct SemiCircle: Shape, Animatable {
    var radius: Double
    
    var animatableData: Double {
        get { radius }
        set { radius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: .zero, y: radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: radius),
            control: CGPoint(x: rect.width * 0.5, y: .zero)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: .zero, y: rect.height))
        return path
    }
}

#Preview {
    SemiCircle(radius: 50)
        .foregroundStyle(.regularMaterial)
        .frame(height: 200)
        .preferredColorScheme(.dark)
}
