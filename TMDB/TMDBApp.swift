//
//  TMDBApp.swift
//  TMDB
//
//  Created by Sameer Mungole on 4/8/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FontLoader.load(name: "Jost-Light", withExtension: "ttf")
        FontLoader.load(name: "Jost-Medium", withExtension: "ttf")
        return true
    }
}

@main
struct TMDBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .animationDuration(1)
                .preferredColorScheme(.dark)
        }
    }
}
