//
//  ContentView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = Router<Route>()
    @StateObject private var errorAlert = ErrorAlert()
    
    var body: some View {
        NavigationStack(path: $router.paths) {
            RSSFeedsView(viewModel: RSSFeedsViewModel())
                .environmentObject(router)
                .environmentObject(errorAlert)
                .navigationDestination(for: Route.self) { getNextView(for: $0) }
        }
        .errorAlert(errorAlert)
    }
    
    @ViewBuilder
    private func getNextView(for route: Route) -> some View {
        switch route {
        case let .itemView(path, viewModel):
            RSSFeedItemsView(path: path, viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
