//
//  ContentView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

struct ContentView: View {
    let networkService = NetworkService()
    let rssParser = RSSParser()
    
    var body: some View {
        RSSFeedsView()
    }
}

#Preview {
    ContentView()
}
