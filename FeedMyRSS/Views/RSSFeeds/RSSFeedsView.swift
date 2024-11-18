//
//  RSSFeedsView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import SwiftUI

struct RSSFeedsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var router: Router<Route>
    @EnvironmentObject var errorAlert: ErrorAlert
    
    @StateObject var viewModel: RSSFeedsViewModel
    @State private var insertingURL = false
    @State private var newURL = ""
    
    var body: some View {
        List {
            ForEach($viewModel.feeds) { $feed in
                RSSFeedRowView(feed: $feed)
                    .onTapGesture { router.push(.itemView(path: feed.path, viewModel: viewModel))}
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
        
        .task { await viewModel.syncStoredData() }
        
        .onChange(of: appState.checkForNewItems) { _, newValue in
            defer { appState.checkForNewItems = false }
            guard newValue else { return }
            
            Task { await viewModel.checkForNewItems() }
        }
        
        .onChange(of: appState.navigateToFeedPath) { _, newValue in
            defer { appState.navigateToFeedPath = "" }
            guard !newValue.isEmpty else { return }
            
            router.goToRoot()
            router.push(.itemView(path: newValue, viewModel: viewModel))
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
        .environmentObject(AppState.shared)
        .environmentObject(Router<Route>())
        .environmentObject(ErrorAlert())
}
