//
//  RSSFeedsViewModel.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Foundation
import Combine

class RSSFeedsViewModel: ObservableObject {
    @Published var feeds = [RSSFeedContent]()
    
    @UserDefaultsWrapper(key: "feedURLs", defaultValue: [])
    var feedURLs: [String]
    
    private let networkService: NetworkServiceProtocol
    private let parser = RSSParser()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func addURL(_ url: String) async throws {
        guard !feedURLs.contains(url) else { throw RSSFeedsError.feedExists }
        
        try await loadRSSFeed(from: url)
        feedURLs.append(url)
    }
    
    func removeFeed(at offsets: IndexSet) {
        feedURLs.remove(atOffsets: offsets)
        feeds.remove(atOffsets: offsets)
    }
    
    func loadStoredFeeds() async throws {
        for url in feedURLs {
            try await loadRSSFeed(from: url)
        }
    }
    
    func loadRSSFeed(from url: String) async throws {
        let data = try await networkService.fetchRSSFeedData(from: url)
        let feed = try await parser.parseRSS(data: data)
        DispatchQueue.main.async {
            self.refreshFeeds(with: feed)
        }
    }
    
    private func refreshFeeds(with feed: RSSFeedContent) {
        if let index = feeds.firstIndex(where: { $0.linkURL == feed.linkURL }) {
            feeds[index] = feed
        } else {
            feeds.append(feed)
        }
    }
}
