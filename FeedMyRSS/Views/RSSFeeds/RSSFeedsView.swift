//
//  RSSFeedsView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import SwiftUI

struct RSSFeedsView: View {
    @EnvironmentObject var appData: AppState
    @EnvironmentObject var errorAlert: ErrorAlert
    
    @StateObject var viewModel: RSSFeedsViewModel
    @State private var insertingURL = false
    @State private var newURL = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.feeds) { $feed in
                    ZStack {
                        NavigationLink(destination: RSSFeedItemsView(path: feed.path, viewModel: viewModel)) {
                            EmptyView() /// This ZStack is a workaround to remove navigation chevron which is automatically inserted by the List
                        }
                        .opacity(0)
                        
                        RSSFeedRowView(feed: $feed)
                    }
                }
                .onDelete(perform: removeRSSFeed)
            }
            .toolbar { createToolbar() }
            .navigationTitle("FeedMyRSS")
            .accessibilityIdentifier("feedList")
            
            .refreshable {
                try? await Task.sleep(for: .seconds(0.5))
                viewModel.retrieveStoredFeeds()
            }
        }
        
        .task { await viewModel.syncStoredData() }
        
        .onChange(of: appData.shouldRefreshFeed) { _, newValue in
            guard newValue else { return }
            Task {
                await viewModel.refreshFeeds()
            }
        }
    }
    
    func removeRSSFeed(at offsets: IndexSet) {
        viewModel.removeFeed(at: offsets)
    }
    
    private func createToolbar() -> ToolbarItemGroup<some View> {
        return ToolbarItemGroup(placement: .bottomBar) {
            VStack {
                Button("Add New Feed") {
                    resetInputText()
                    insertingURL.toggle()
                }
                .buttonStyle(RoundedButtonStyle())
                .padding()
                
                inputTextAlert
            }
        }
    }
    
    var inputTextAlert: some View {
        VStack {}
            .alert("Add new RSS feed", isPresented: $insertingURL) {
                TextField("URL", text: $newURL)
                    .textInputAutocapitalization(.never)
                Button("OK", action: addNewFeed)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Insert URL")
            }
    }
    
    private func addNewFeed() {
        Task {
            do {
                try await viewModel.addURL(newURL)
            } catch {
                errorAlert.show(error: error)
            }
        }
    }
}

extension RSSFeedsView {
    private func resetInputText() {
#if DEBUG
        let someRSSFeedURLs = ["https://feeds.bbci.co.uk/news/world/rss.xml",
        "https://feeds.feedburner.com/time/world",
        "https://www.cnbc.com/id/100727362/device/rss/rss.html",
        "https://abcnews.go.com/abcnews/internationalheadlines",
        "https://www.cbsnews.com/latest/rss/world"]
        newURL = someRSSFeedURLs.randomElement() ?? ""
#else
        newURL = ""
#endif
    }
}

#Preview {
    RSSFeedsView(viewModel: RSSFeedsViewModel(networkService: NetworkService()))
        .environmentObject(ErrorAlert())
}
