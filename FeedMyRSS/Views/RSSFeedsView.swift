//
//  RSSFeedsView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import SwiftUI

struct RSSFeedsView: View {
    @EnvironmentObject var errorAlert: ErrorAlert
    
    @StateObject var viewModel: RSSFeedsViewModel
    @State private var insertingURL = false
    @State private var newURL = ""
    
    var body: some View {
        NavigationView {
            List(viewModel.feeds, id: \.linkURL) { feed in
                RSSFeedRowView(feed: feed)
            }
            .toolbar {
                createToolbar()
            }
    
            .navigationTitle("FeedMyRSS")
        }
    }
    
    private func createToolbar() -> ToolbarItemGroup<some View> {
        return ToolbarItemGroup(placement: .bottomBar) {
            Button("Add New Feed") {
                insertingURL.toggle()
            }
            .buttonStyle(RoundedButtonStyle())
            .padding()
            .alert("Add new RSS feed", isPresented: $insertingURL) {
                TextField("URL", text: $newURL)
                    .textInputAutocapitalization(.never)
                Button("OK", action: addNewFeed)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Insert URL")
            }
        }
    }
    
    private func addNewFeed() {
        Task {
            do {
                try await viewModel.addURL("https://feeds.bbci.co.uk/news/world/rss.xml")
            } catch {
                errorAlert.show(error: error)
            }
        }
    }
}

#Preview {
    RSSFeedsView(viewModel: RSSFeedsViewModel(networkService: NetworkService()))
}
