//
//  NetworkTests.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 06.11.2024.
//

import Testing
import Foundation
@testable import FeedMyRSS

struct NetworkTests {
    let sut: NetworkService
    let mockSession: MockURLSession
    
    init() {
        mockSession = MockURLSession()
        sut = NetworkService(session: mockSession)
    }
    
    @Test func getRSSFeedData_Success() async throws {
        let RSSData = """
        <rss>
            <channel>
                <title>Sample Feed</title>
                <description>This is a sample RSS feed</description>
                <link>https://example.com</link>
                <item>
                    <title>Item</title>
                    <description>Item description</description>
                    <link>https://example.com/item</link>
                    <media:thumbnail url="https://example.com/image.jpg" />
                </item>
            </channel>
        </rss>
        """.data(using: .utf8)!
        
        mockSession.data = RSSData
        
        let response = try await sut.fetchRSSFeedData(from: "https://mockme.com/")
        
        #expect(response == RSSData)
    }
    
    @Test func getRSSFeedData_RequestFailed() async throws {
        let requestError = URLError(.notConnectedToInternet)
        mockSession.data = Data()
        mockSession.error = requestError
        
        do {
            let _ = try await sut.fetchRSSFeedData(from: "https://mockme.com/")
        } catch let error as NetworkServiceError {
            guard case .requestFailed(let error) = error else {
                Issue.record("Expected URLError, but got NetworkServiceError")
                return
            }
            #expect(error as? URLError == requestError)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test func getRSSFeedData_InvalidResponseStatusCode() async throws {
        mockSession.data = Data()
        mockSession.statusCode = 404
        
        do {
            let _ = try await sut.fetchRSSFeedData(from: "https://mockme.com/")
        } catch let error as NetworkServiceError {
            guard case .invalidResponse = error else {
                Issue.record("Wrong error returned: \(error) instead of .invalidResponse")
                return
            }
            #expect(error != nil)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
