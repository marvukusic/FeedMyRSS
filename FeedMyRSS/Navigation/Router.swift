//
//  Router.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 18.11.2024.
//

import Combine

class Router<Route: Hashable>: ObservableObject {
    @Published var paths: [Route] = []
    
    func push(_ route: Route) {
        paths.append(route)
    }
    
    func pop() {
        paths.removeLast()
    }
}
