//
//  FavoriteAnimeRow.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct FavoriteAnimeRow: View {
    let anime: AnimeData
    
    var body: some View {
        HStack {
            // Image
            if let imageURL = URL(string: anime.images.jpg.imageURL) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 120)
                            .clipped()
                            .cornerRadius(6)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 80, height: 120)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(6)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .frame(width: 80, height: 120)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(6)
            }
            
            // Information
            VStack(alignment: .leading, spacing: 4) {
                Text(anime.title)
                    .font(.headline)
                    .lineLimit(2)
                
                if let score = anime.score {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(score, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    if let type = anime.type {
                        Text(type)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                    
                    if let episodes = anime.episodes {
                        Text("\(episodes) eps")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 4)
    }
}
