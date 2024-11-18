//
//  Route.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 18.11.2024.
//

import Foundation

enum Route: Hashable {
    case itemView(path: String, viewModel: RSSFeedsViewModel)
}
