//
//  MockURLSession.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 06.11.2024.
//

import Foundation
@testable import FeedMyRSS

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    var statusCode: Int = 200
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        return (data ?? Data(), response)
    }
}
