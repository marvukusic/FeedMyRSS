//
//  AppState.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 13.11.2024.
//

import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var checkForNewItems = false
    
    private init() {}
}
