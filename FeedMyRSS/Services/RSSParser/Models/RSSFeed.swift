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
    var content: RSSFeedContent
    var isFavourited    = false
    var newItems        = false
    var newItemCount    = 0
}

extension RSSFeed: Equatable {
    static func == (lhs: RSSFeed, rhs: RSSFeed) -> Bool {
        lhs.path == rhs.path &&
        lhs.isFavourited == rhs.isFavourited &&
        lhs.content.items.count == rhs.content.items.count
    }
}
