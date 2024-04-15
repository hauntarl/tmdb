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
        Font.load(name: "Jost-Light", withExtension: "ttf")
        Font.load(name: "Jost-Medium", withExtension: "ttf")
        return true
    }
}

@main
struct TMDBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .animationDuration(0.75)
                .preferredColorScheme(.dark)
        }
    }
}
