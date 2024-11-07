//
//  RSSFeedsView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import SwiftUI

struct RSSFeedsView: View {
    @StateObject var viewModel: RSSFeedsViewModel
    
    var body: some View {
        Button("Pressme") {
            Task {
                do {
                    try await viewModel.loadRSSFeed(from: "https://feeds.bbci.co.uk/news/world/rss.xml")
                } catch {
                    print(error)
#warning("Handle errors")
                }
            }
        }
    }
}

#Preview {
    RSSFeedsView(viewModel: RSSFeedsViewModel(networkService: NetworkService()))
}
