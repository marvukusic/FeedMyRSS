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
    let mockSession: MockNetworkService
    
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
        mockSession = MockNetworkService()
        sut = RSSFeedsViewModel(networkService: mockSession)
    }
    
    @Test @MainActor func syncStoredData() async throws {
        let storedFeed = RSSFeed(path: someUrl, content: RSSFeedContent(title: "Sample Feed", description: "This is a sample RSS feed", linkURL: URL(string: "https://example.com")))
        sut.storedFeeds = [storedFeed]
        
        await sut.syncStoredData()
        
        #expect(sut.feeds == [storedFeed])
    }
}
