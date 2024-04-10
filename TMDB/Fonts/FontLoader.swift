//
//  FontLoader.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/10/24.
//
// Load custom font: https://stackoverflow.com/a/66105745

import CoreText
import CoreGraphics
import SwiftUI

class FontLoader {
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
        } else {
            print("Font: \(name).\(withExtension) loaded successfully.")
        }
    }
}

extension Font {
    static let jostMedium = "Jost-Medium"
    static let jostLight = "Jost-Light"
}
