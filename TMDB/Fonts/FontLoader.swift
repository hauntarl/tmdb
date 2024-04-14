//
//  FontLoader.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/10/24.
//
//  Load custom font: https://stackoverflow.com/a/66105745

import CoreText
import CoreGraphics
import SwiftUI

final class FontLoader {
    static func load(name: String, withExtension: String) {
        guard
            let url = Bundle(for: FontLoader.self).url(forResource: name, withExtension: withExtension),
            let dataProvider = CGDataProvider(url: url as CFURL),
            let font = CGFont(dataProvider)
        else {
            assertionFailure("Error loading Font: \(name).\(withExtension).")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error loading Font: \(name).\(withExtension).")
        }
    }
}

extension Font {
    static func jostLight(size: CGFloat) -> Self {
        .custom("Jost-Light", size: size)
    }

    static func jostMedium(size: CGFloat) -> Self {
        .custom("Jost-Medium", size: size)
    }
}

