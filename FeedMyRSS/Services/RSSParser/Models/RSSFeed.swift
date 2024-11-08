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
    let content: RSSFeedContent
}
