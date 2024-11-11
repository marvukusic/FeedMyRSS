//
//  RSSFeed.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 08.11.2024.
//

import Foundation

struct RSSFeed: Codable, Identifiable {
    var id: String { path }
    let path: String
    var isFavourited: Bool = false
    let content: RSSFeedContent
}

extension RSSFeed: Equatable {
    static func == (lhs: RSSFeed, rhs: RSSFeed) -> Bool {
        lhs.path == rhs.path &&
        lhs.isFavourited == rhs.isFavourited
    }
}
