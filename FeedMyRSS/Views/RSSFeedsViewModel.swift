//
//  RSSFeedsViewModel.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import Foundation
import Combine

class RSSFeedsViewModel: ObservableObject {
    @Published var feeds = [RSSFeed]()
    
    
}
