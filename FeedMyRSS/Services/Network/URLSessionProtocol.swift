//
//  URLSessionProtocol.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 06.11.2024..
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
