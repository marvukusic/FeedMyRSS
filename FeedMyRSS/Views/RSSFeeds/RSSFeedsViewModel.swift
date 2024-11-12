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
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func syncStoredData() async {
        await retrieveStoredFeeds()
        
        $feeds
            .removeDuplicates()
            .filter { $0 != self.storedFeeds }
            .sink { [weak self] newValue in
                self?.storedFeeds = newValue.sorted(by: { $0.isFavourited && !$1.isFavourited })
            }
            .store(in: &subscribers)
    }
    
    func addURL(_ urlString: String) async throws {
        guard !feedExists(for: urlString) else { throw RSSFeedsError.feedExists }
        
        let feed = try await loadRSSFeed(from: urlString)
        await addFeed(feed)
    }
    
    func loadRSSFeed(from urlString: String) async throws -> RSSFeed {
        let data = try await networkService.fetchRSSFeedData(from: urlString)
        let content = try await parser.parseRSS(data: data)
        let feed = RSSFeed(path: urlString, content: content)
        return feed
    }
    
    @MainActor
    func addFeed(_ feed: RSSFeed) {
        feeds.append(feed)
    }
    
    @MainActor
    func removeFeed(at offsets: IndexSet) {
        feeds.remove(atOffsets: offsets)
    }
    
    @MainActor
    func retrieveStoredFeeds() {
        feeds = storedFeeds
    }
    
    private func feedExists(for urlString: String) -> Bool {
        feeds.contains(where: { $0.path == urlString })
    }
}
