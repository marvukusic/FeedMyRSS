//
//  NetworkService.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 06.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchRSSFeedData(from urlString: String) async throws -> Data
}

class NetworkService: NetworkServiceProtocol {
    internal protocol URLSessionProtocol {
        func data(from url: URL) async throws -> (Data, URLResponse)
    }
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRSSFeedData(from urlString: String) async throws -> Data {
        guard urlString.isValidURL, let url = URL(string: urlString) else {
            throw NetworkServiceError.invalidURL
        }
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkServiceError.requestFailed(error)
        }
        
        try validateResponse(response)
        
        return data
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponse
        }
    }
}

extension URLSession: NetworkService.URLSessionProtocol {}
