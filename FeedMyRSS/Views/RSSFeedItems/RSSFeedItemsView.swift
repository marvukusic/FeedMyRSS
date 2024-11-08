//
//  RSSFeedItemsView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 08.11.2024.
//

import SwiftUI
import Combine

struct WebViewModel: Identifiable {
    var id = UUID()
    var linkURL: URL?
}

struct RSSFeedItemsView: View {
    @EnvironmentObject var errorAlert: ErrorAlert
    
    let path: String
    @StateObject var viewModel: RSSFeedsViewModel
    
    @State private var webViewModel: WebViewModel?
    
    @State private var feed: RSSFeed?
    private var items: [RSSItem] { feed?.content.items ?? [] }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(items) { item in
                    RSSFeedItemRowView(item: item)
                        .onTapGesture {
                            webViewModel = WebViewModel(linkURL: item.linkURL)
                        }
                    Divider()
                }
            }
        }
        .refreshable {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await loadFeed()
        }
        
        .navigationTitle(feed?.content.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        
        .task { await loadFeed() }
        
        .sheet(item: $webViewModel) { model in
            WebView(url: model.linkURL)
        }
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
