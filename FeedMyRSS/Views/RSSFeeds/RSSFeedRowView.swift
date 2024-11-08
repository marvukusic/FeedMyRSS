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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feed.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(feed.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RSSFeedRowView(feed: RSSFeedContent(title: "Title", description: "Description", imageURL: URL(string: "www.image.url")))
}
