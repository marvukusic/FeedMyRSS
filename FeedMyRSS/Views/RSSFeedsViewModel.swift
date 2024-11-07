//
//  RSSFeedsViewModel.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Foundation
import Combine

class RSSFeedsViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let parser = RSSParser()
    
    @Published var feeds = [RSSFeed]()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
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
