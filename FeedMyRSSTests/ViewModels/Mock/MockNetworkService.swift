//
//  MockNetworkService.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 12.11.2024..
//

import XCTest
@testable import FeedMyRSS

class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    
    func fetchRSSFeedData(from url: String) async throws -> Data {
        if let data = mockData {
            return data
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
