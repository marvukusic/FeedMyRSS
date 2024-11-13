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
            guard var newFeed = try? await loadRSSFeed(from: feeds[index].path) else { continue }
            
            let item = RSSItem(title: "Tit", description: "Descr", linkURL: URL(string: "https://newItem.com/\(Int.random(in: 0..<1000))"))
            let item2 = RSSItem(title: "Tit", description: "Descr", linkURL: URL(string: "https://newItem.com/\(Int.random(in: 0..<1000))"))
            newFeed.content.items.append(item)
            newFeed.content.items.append(item2)
                               
            let newFeedItemsSet = Set<RSSItem>(newFeed.content.items)
            let oldFeedItemsSet = Set<RSSItem>(feeds[index].content.items)
            let newItems = newFeedItemsSet.subtracting(oldFeedItemsSet)
            if newItems.count > 0 {
                await updateFeedItems(forIndex: index, with: newFeed.content.items, newItemCount: newItems.count)
                sendNotification(for: feeds[index])
            }
        }
    }
    
    @MainActor
    private func updateFeedItems(forIndex index: Int, with items: [RSSItem], newItemCount count: Int) {
        feeds[index].newItems = true
        feeds[index].newItemCount = count
        feeds[index].content.items = items
    }
    
    private func sendNotification(for feed: RSSFeed) {
        guard feed.isFavourited else { return }
        
        let title = feed.content.title ?? ""
        let message = "new item".pluraliseIfNeeded(for: feed.newItemCount)
        LocalNotification(title: title, subtitle: message).send()
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
