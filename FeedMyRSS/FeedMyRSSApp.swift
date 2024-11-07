//
//  FeedMyRSSApp.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

@main
struct FeedMyRSSApp: App {
    private let networkService = NetworkService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.networkService, networkService)
        }
    }
}
