//
//  RSSFeedItemRowView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024.
//

import SwiftUI

struct RSSFeedItemRowView: View {
    let item: RSSItem
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: item.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    
            } placeholder: {
                ZStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundStyle(.gray)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        .frame(height: 200)
                }
            }
            
            VStack(alignment: .leading) {
                Text(item.title ?? "")
                    .font(.headline)
                
                Text(item.description ?? "No description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical)
    }
}

#Preview {
    RSSFeedItemRowView(item: RSSItem(title: "Title", description: "Description", imageURL: URL(string: "www.image.url")))
}
