//
//  RSSFeedsViewModelTests.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 12.11.2024.
//

import Testing
import Foundation
import XCTest
@testable import FeedMyRSS

struct RSSFeedsViewModelTests {
    let sut: RSSFeedsViewModel!
    let mockService: MockNetworkService
    
    let someUrl = "https://someurl.com/"
    let invalidUrl = "invalid-url"
    
    let RSSData = """
<rss>
    <channel>
        <title>Sample Feed</title>
        <description>This is a sample RSS feed</description>
        <link>https://example.com</link>
    </channel>
</rss>
""".data(using: .utf8)!
    
    init() {
        mockService = MockNetworkService()
        sut = RSSFeedsViewModel(networkService: mockService)
    }
    
    @Test func syncStoredData() async throws {
        let storedFeed = RSSFeed(path: someUrl, content: RSSFeedContent(title: "Sample Feed", description: "This is a sample RSS feed", linkURL: URL(string: "https://example.com")))
        sut.storedFeeds = [storedFeed]
        
        await sut.syncStoredData()
        
        #expect(sut.feeds == [storedFeed])
    }
    
    @Test func addURLSuccessfullyAddsFeed() async throws {
        mockService.mockData = RSSData
        
        try await sut.addURL(someUrl)
        
        #expect(sut.feeds.count == 1)
        #expect(sut.feeds.first?.path == someUrl)
    }
    
    @Test func addURLThrowsErrorWhenFeedAlreadyExists() async throws {
        mockService.mockData = RSSData
        
        try await sut.addURL(someUrl)
        
        await #expect(throws: RSSFeedsError.feedExists) {
            try await sut.addURL(someUrl)
        }
    }
    
    @Test func removeFeedSuccessfullyRemovesItFromFeedList() async throws {
        mockService.mockData = RSSData
        
        try await sut.addURL(someUrl)
        #expect(sut.feeds.count == 1)
        
        await sut.removeFeed(at: [0])
        #expect(sut.feeds.count == 0)
    }
}
