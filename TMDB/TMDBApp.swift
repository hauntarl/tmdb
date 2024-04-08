//
//  TMDBApp.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

@main
struct TMDBApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .animationDuration(0.5)
                .preferredColorScheme(.dark)
        }
    }
}
