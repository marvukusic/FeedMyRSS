//
//  ContentView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var errorAlert = ErrorAlert()
    
    var body: some View {
        VStack {
            RSSFeedsView(viewModel: RSSFeedsViewModel())
                .environmentObject(errorAlert)
        }
        .errorAlert(errorAlert)
    }
}

#Preview {
    ContentView()
}
