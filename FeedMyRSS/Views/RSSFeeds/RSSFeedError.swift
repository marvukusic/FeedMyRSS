//
//  RSSFeedError.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Foundation

enum RSSFeedsError: LocalizedError {
    case feedExists
    
    var errorDescription: String? {
        switch self {
        case .feedExists:
            return "RSS feed already in list"
        }
    }
}
