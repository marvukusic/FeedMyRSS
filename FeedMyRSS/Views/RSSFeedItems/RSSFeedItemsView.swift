//
//  RSSFeedItemsView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 08.11.2024.
//

import SwiftUI
import Combine

struct RSSFeedItemsView: View {
    @EnvironmentObject var errorAlert: ErrorAlert
    
    let path: String
    @StateObject var viewModel: RSSFeedsViewModel
    
    @State private var feed: RSSFeed?
    var items: [RSSItem] { feed?.content.items ?? [] }
    
    var body: some View {
        List(items) { item in
            RSSFeedItemRowView(item: item)
        }
        .navigationTitle(feed?.content.title ?? "")
        .task { await loadFeed() }
    }
    
    private func loadFeed() async {
        do {
            feed = try await viewModel.loadRSSFeed(from: path)
        } catch {
            errorAlert.show(error: error)
        }
    }
}

#Preview {
    RSSFeedItemsView(path: "", viewModel: RSSFeedsViewModel(networkService: NetworkService()))
}
