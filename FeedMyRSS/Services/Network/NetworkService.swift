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
        guard let url = URL(string: urlString) else { throw NetworkServiceError.invalidURL }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkServiceError.invalidResponse
            }
            
            return data
        } catch {
            throw NetworkServiceError.requestFailed(error)
        }
    }
}
