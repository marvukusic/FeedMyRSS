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
    
    private var subscribers = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func syncStoredData() {
        DispatchQueue.main.async {
            self.feeds = self.storedFeeds
        }
        
        $feeds
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0 != self.storedFeeds }
            .sink { [weak self] newValue in
                self?.storedFeeds = newValue.sorted(by: { $0.isFavourited && !$1.isFavourited })
            }
            .store(in: &subscribers)
    }
    
    func addURL(_ urlString: String) async throws {
        guard !feedExists(for: urlString) else { throw RSSFeedsError.feedExists }
        
        let feed = try await loadRSSFeed(from: urlString, skipItems: true)
        DispatchQueue.main.async {
            self.feeds.append(feed)
        }
    }
    
    func removeFeed(at offsets: IndexSet) {
        feeds.remove(atOffsets: offsets)
    }
    
    func loadRSSFeed(from urlString: String, skipItems: Bool = false) async throws -> RSSFeed {
        let data = try await networkService.fetchRSSFeedData(from: urlString)
        let content = try await parser.parseRSS(data: data, skipItems: skipItems)
        let feed = RSSFeed(path: urlString, content: content)
        return feed
    }
    
    private func feedExists(for urlString: String) -> Bool {
        feeds.contains(where: { $0.path == urlString })
    }
}
