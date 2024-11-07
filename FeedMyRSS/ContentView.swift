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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Download RSS") {
                Task {
                    do {
                        let data = try await networkService.fetchRSSFeedData(from: "https://feeds.bbci.co.uk/news/world/rss.xml")
                        let feed = try await rssParser.parseRSS(data: data)
                        print(feed)
                    } catch {
                        print(error)
                    }
                    
                    
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
