//
//  RSSFeedContent.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024.
//

import Foundation

struct RSSFeedContent: Codable {
    var title: String = ""
    var description: String = ""
    var linkURL: URL?
    var imageURL: URL?
    var items = [RSSItem]()
}
