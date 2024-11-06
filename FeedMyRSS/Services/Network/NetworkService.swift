//
//  NetworkService.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 06.11.2024.
//

import Foundation

class NetworkService {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchRSSFeedData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString), isValidURLComponents(urlString) else {
            throw NetworkServiceError.invalidURL
        }
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkServiceError.requestFailed(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponse
        }
        
        return data
    }
    
    private func isValidURLComponents(_ urlString: String) -> Bool {
        guard let components = URLComponents(string: urlString) else { return false }
        return ["http", "https"].contains(components.scheme?.lowercased()) && components.host != nil
    }
}
