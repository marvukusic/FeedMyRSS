//
//  RSSFeedItemRowView.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 07.11.2024.
//

import SwiftUI

struct RSSFeedItemRowView: View {
    let item: RSSItem
    
    let imageSize: CGFloat = 120
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: item.imageURL) { image in
                image
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
                    .scaledToFit()
                    .cornerRadius(8)
                    
            } placeholder: {
                ZStack {
                    Image(systemName: "photo.on.rectangle")
                        .foregroundStyle(.gray)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        .frame(width: imageSize, height: imageSize)
                }
            }
            
            VStack(alignment: .leading) {
                Group {
                    Text(item.title ?? "")
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(item.description ?? "No description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    RSSFeedItemRowView(item: RSSItem(title: "Title", description: "Description", imageURL: URL(string: "www.image.url")))
}
