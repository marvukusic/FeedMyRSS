//
//  ContentView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

struct ContentView: View {
    @Environment(\.networkService) private var networkService: NetworkServiceProtocol
    
    @StateObject private var errorAlert = ErrorAlert()
    
    var body: some View {
        VStack {
            RSSFeedsView(viewModel: RSSFeedsViewModel(networkService: networkService))
                .environmentObject(errorAlert)
        }
        .errorAlert(errorAlert)
    }
}

#Preview {
    ContentView()
}
