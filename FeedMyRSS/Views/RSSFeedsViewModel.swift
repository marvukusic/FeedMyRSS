//
//  RSSFeedsViewModel.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Foundation
import Combine

class RSSFeedsViewModel: ObservableObject {
    @Published var feeds = [RSSFeed]()
    
    @UserDefaultsWrapper(key: "feedURLs", defaultValue: [])
    private var feedURLs: [String]
    
    private let networkService: NetworkServiceProtocol
    private let parser = RSSParser()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func addURL(_ url: String) async throws {
        guard !feedURLs.contains(url) else { return }
        
        try await loadRSSFeed(from: url)
        feedURLs.append(url)
    }
    
    func removeURL(_ url: String) {
        feedURLs.removeAll(where: { $0 == url })
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
    
    private func refreshFeeds(with feed: RSSFeed) {
        if let index = feeds.firstIndex(where: { $0.linkURL == feed.linkURL }) {
            feeds[index] = feed
        } else {
            feeds.append(feed)
        }
    }
}
