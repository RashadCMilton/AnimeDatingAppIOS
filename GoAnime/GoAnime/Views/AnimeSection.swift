//
//  AnimeSection.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct AnimeSection: View {
    let title: String
    let anime: [AnimeData]
    let isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.leading, 8)
            
            if isLoading {
                LoadingView()
            } else if anime.isEmpty {
                Text("No anime found")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(anime) { item in
                            AnimeCardView(anime: item)
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
    }
}
