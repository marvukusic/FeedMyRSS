//
//  RSSItem.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024.
//

import Foundation

struct RSSItem: Codable, Identifiable, Hashable {
    var id: String { linkURL?.absoluteString ?? UUID().uuidString }
    var title: String?
    var description: String?
    var imageURL: URL?
    var linkURL: URL?
}

extension RSSItem: Equatable {
    static func == (lhs: RSSItem, rhs: RSSItem) -> Bool {
        lhs.linkURL == rhs.linkURL
    }
}
