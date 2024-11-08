//
//  RSSItem.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024.
//

import Foundation

struct RSSItem: Codable {
    var title: String = ""
    var description: String = ""
    var imageURL: URL?
    var linkURL: URL?
}
