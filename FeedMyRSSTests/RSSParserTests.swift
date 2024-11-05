//
//  RSSParserTests.swift
//  FeedMyRSSTests
//
//  Created by Marko Vukušić on 05.11.2024..
//

import Testing
import Foundation
@testable import FeedMyRSS

struct RSSParserTests {
    var sut: RSSParser
    
    init() {
        sut = RSSParser()
    }

    @Test func parseValidRSSFeed() async throws {
        let RSSData = """
        <rss>
            <channel>
                <title>Sample Feed</title>
                <description>This is a sample RSS feed</description>
                <link>https://example.com</link>
                <item>
                    <title>Item 1</title>
                    <description>Item 1 description</description>
                    <link>https://example.com/item1</link>
                    <media:thumbnail url="https://example.com/image1.jpg" />
                </item>
                <item>
                    <title>Item 2</title>
                    <description>Item 2 description</description>
                    <link>https://example.com/item2</link>
                    <media:thumbnail url="https://example.com/image2.jpg" />
                </item>
            </channel>
        </rss>
        """.data(using: .utf8)!
        
        let feed = try await sut.parseRSS(data: RSSData)
        
        #expect(feed.title == "Sample Feed")
        #expect(feed.description == "This is a sample RSS feed")
        #expect(feed.items.count == 2)
        
        let item1 = feed.items[0]
        #expect(item1.title == "Item 1")
        #expect(item1.description == "Item 1 description")
        #expect(item1.linkURL == URL(string: "https://example.com/item1"))
        #expect(item1.imageURL == URL(string: "https://example.com/image1.jpg"))
        
        let item2 = feed.items[1]
        #expect(item2.title == "Item 2")
        #expect(item2.description == "Item 2 description")
        #expect(item2.linkURL == URL(string: "https://example.com/item2"))
        #expect(item2.imageURL == URL(string: "https://example.com/image2.jpg"))
    }
    
    @Test func parseEmptyRSSFeed() async throws {
        let RSSData = """
        <rss>
            <channel>
            </channel>
        </rss>
        """.data(using: .utf8)!
        
        let feed = try await sut.parseRSS(data: RSSData)
        
        #expect(feed.title == "")
        #expect(feed.description == "")
        #expect(feed.items.count == 0)
    }
    
    @Test func parseMissingElements() async throws {
        let RSSData = """
        <rss>
            <channel>
                <title>Missing Description</title>
                <link>https://example.com</link>
                <item>
                    <title>Item with Missing Description</title>
                    <link>https://example.com/item</link>
                </item>
            </channel>
        </rss>
        """.data(using: .utf8)!
        
        let feed = try await sut.parseRSS(data: RSSData)
        
        #expect(feed.title == "Missing Description")
        #expect(feed.description == "")
        #expect(feed.items.count == 1)
        
        let item = feed.items[0]
        #expect(item.title == "Item with Missing Description")
        #expect(item.description == "")
        #expect(item.linkURL == URL(string: "https://example.com/item"))
    }
    
    @Test func parseInvalidURL() async throws {
        let RSSData = """
        <rss>
            <channel>
                <title>Feed with Invalid URL</title>
                <item>
                    <title>Item with Invalid URL</title>
                    <link>ht!tp://invalid-url</link>
                </item>
            </channel>
        </rss>
        """.data(using: .utf8)!
        
        let feed = try await sut.parseRSS(data: RSSData)
        
        #expect(feed.title == "Feed with Invalid URL")
        #expect(feed.description == "")
        #expect(feed.items.count == 1)
        
        let item = feed.items[0]
        #expect(item.title == "Item with Invalid URL")
        #expect(item.imageURL == nil)
    }

}
