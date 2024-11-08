//
//  RSSFeedsViewModel.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Foundation
import Combine

class RSSFeedsViewModel: ObservableObject {
    @UserDefaultsWrapper(key: "storedFeeds", defaultValue: [])
    var storedFeeds: [RSSFeed]
    
    @Published var feeds = [RSSFeed]()
    
    private let networkService: NetworkServiceProtocol
    private let parser = RSSParser()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func addURL(_ urlString: String) async throws {
        guard !feedExists(for: urlString) else { throw RSSFeedsError.feedExists }
        
        try await loadRSSFeed(from: urlString)
    }
    
    func removeFeed(at offsets: IndexSet) {
        feeds.remove(atOffsets: offsets)
        syncStoredFeeds()
    }
    
    func loadStoredFeeds() async throws {
        DispatchQueue.main.async {
            self.feeds = self.storedFeeds
        }
    }
    
    func loadRSSFeed(from urlString: String) async throws {
        let data = try await networkService.fetchRSSFeedData(from: urlString)
        let content = try await parser.parseRSS(data: data)
        let feed = RSSFeed(path: urlString, content: content)
        DispatchQueue.main.async {
            self.refreshFeeds(with: feed)
        }
    }
    
    private func refreshFeeds(with feed: RSSFeed) {
        if let index = storedFeeds.firstIndex(where: { $0.path == feed.path }) {
            feeds[index] = feed
        } else {
            feeds.append(feed)
        }
        syncStoredFeeds()
    }
    
    private func syncStoredFeeds() {
        storedFeeds = feeds
    }
    
    private func feedExists(for urlString: String) -> Bool {
        feeds.contains(where: { $0.path == urlString })
    }
}