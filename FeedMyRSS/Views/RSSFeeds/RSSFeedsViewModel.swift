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
    
    func refreshFeeds() async {
        for index in feeds.indices {
            guard let newFeed = try? await loadRSSFeedFromBackground(from: feeds[index].path) else { continue }
                               
            let newFeedItemsSet = Set<RSSItem>(newFeed.content.items)
            let oldFeedItemsSet = Set<RSSItem>(feeds[index].content.items)
            let newItems = newFeedItemsSet.subtracting(oldFeedItemsSet)
            if newItems.count > 0 {
                await updateFeedItems(forIndex: index, with: newFeed.content.items, newItemCount: newItems.count)
                sendNotification(for: feeds[index])
            }
        }
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
        return RSSFeed(path: urlString, content: content)
    }
    
    func loadRSSFeedFromBackground(from urlString: String) async throws -> RSSFeed {
        let data = try await networkService.fetchRSSFeedDataFromBackground(from: urlString)
        let content = try await parser.parseRSS(data: data)
        return RSSFeed(path: urlString, content: content)
    }
    
    @MainActor
    func removeFeed(at offsets: IndexSet) {
        feeds.remove(atOffsets: offsets)
    }
    
    @MainActor
    func retrieveStoredFeeds() {
        feeds = storedFeeds
    }
    
    @MainActor
    private func addFeed(_ feed: RSSFeed) {
        feeds.append(feed)
    }
    
    @MainActor
    private func updateFeedItems(forIndex index: Int, with items: [RSSItem], newItemCount count: Int) {
        feeds[index].newItemCount = count
        feeds[index].content.items = items
    }
    
    private func sendNotification(for feed: RSSFeed) {
        guard feed.isFavourited else { return }
        
        let title = feed.content.title ?? ""
        let message = "new item".pluraliseIfNeeded(for: feed.newItemCount)
        LocalNotification(title: title, subtitle: message).send()
    }
    
    private func feedExists(for urlString: String) -> Bool {
        feeds.contains(where: { $0.path == urlString })
    }
}
