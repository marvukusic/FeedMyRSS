//
//  FeedMyRSSIntegrationTests.swift
//  FeedMyRSSIntegrationTests
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Testing
import Foundation
@testable import FeedMyRSS

struct FeedMyRSSIntegrationTests {
    
    let networkService: NetworkService
    let mockSession: MockURLSession
    let parser: RSSParser
    
    init() {
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
        parser = RSSParser()
    }
    
    
    @Test func fetchRSSFeed_deliversRSSFeedModel() async throws {
        let RSSData = """
        <rss>
            <channel>
                <title>Sample Feed</title>
                <description>This is a sample RSS feed</description>
                <link>https://example.com</link>
            </channel>
        </rss>
        """.data(using: .utf8)!
        
        mockSession.data = RSSData
        
        do {
            let data = try await networkService.fetchRSSFeedData(from: "https://mockme.com/")
            let feed = try await parser.parseRSS(data: data)
            
            #expect(feed.title == "Sample Feed")
            #expect(feed.description == "This is a sample RSS feed")
            #expect(feed.items.count == 0)
        } catch {
            Issue.record("Error \(error) throwed, but no errors should be present")
        }
    }
}
