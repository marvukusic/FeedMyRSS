//
//  NetworkServiceError.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 06.11.2024..
//

import Foundation

enum NetworkServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .requestFailed(let error):
            return "Request failed with error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Received an invalid response from the server."
        }
    }
}
