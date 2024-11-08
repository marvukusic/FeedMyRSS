//
//  RSSFeedRowView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024..
//

import SwiftUI

struct RSSFeedRowView: View {
    let feed: RSSFeedContent
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: feed.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } placeholder: {
                ZStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundStyle(.gray)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feed.title ?? "")
                    .font(.headline)
                    .lineLimit(1)
                
                Text(feed.description ?? "No description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RSSFeedRowView(feed: RSSFeedContent(title: "Title", description: "Description", imageURL: URL(string: "www.image.url")))
}
