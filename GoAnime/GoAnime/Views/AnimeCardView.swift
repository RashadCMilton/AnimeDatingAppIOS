//
//  AnimeCardView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct AnimeCardView: View {
    let anime: AnimeData
    
    var body: some View {
        NavigationLink(destination: AnimeDetailView(anime: anime)) {
            VStack(alignment: .leading) {
                // Anime image
                AsyncImage(url: URL(string: anime.images.jpg.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.3))
                            .aspectRatio(3/4, contentMode: .fill)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .aspectRatio(3/4, contentMode: .fill)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 150, height: 200)
                .cornerRadius(8)
                .clipped()
                
                // Anime title - limit to 2 lines
                Text(anime.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .frame(width: 150, alignment: .leading)
                    .foregroundColor(.primary)
                
                // Rating if available
                if let score = anime.score, score > 0 {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", score))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 150)
        }
    }
}

#Preview {
   // AnimeCardView(anime: AnimeData.init())
}
