//
//  RSSParserError.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024.
//

import Foundation

enum RSSParserError: LocalizedError {
    case errorParsingXML
    
    var errorDescription: String? {
        switch self {
        case .errorParsingXML:
            return "URL link does not contain a valid RSS feed"
        }
    }
}
