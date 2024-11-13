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
    @ObservedObject var viewModel: RSSFeedsViewModel
    
    @State private var webViewModel: WebViewModel?
    
    @State private var feed: RSSFeed?
    @State private var isLoading = false
    
    private var items: [RSSItem] { feed?.content.items ?? [] }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(items) { item in
                    RSSFeedItemRowView(item: item)
                        .onTapGesture {
                            openLink(item.linkURL)
                        }
                    Divider()
                }
            }
        }
        .refreshable {
            try? await Task.sleep(for: .seconds(0.5))
            await loadFeed()
        }
        
        .navigationTitle(feed?.content.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        
        .task { await loadFeed() }
        
        .sheet(item: $webViewModel) { model in
            ZStack {
                WebView(isLoading: $isLoading, url: model.linkURL)
                
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                }
            }
        }
    }
    
    private func openLink(_ linkURL: URL?) {
        webViewModel = WebViewModel(linkURL: linkURL)
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
        .environmentObject(ErrorAlert())
}
