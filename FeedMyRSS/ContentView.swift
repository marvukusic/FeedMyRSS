//
//  ContentView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

struct ContentView: View {
    @Environment(\.networkService) private var networkService: NetworkServiceProtocol
    
    var body: some View {
        RSSFeedsView(viewModel: RSSFeedsViewModel(networkService: networkService))
    }
}

#Preview {
    ContentView()
}
