//
//  FavoritesView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        NavigationView {
            Group {
                if favoritesManager.favorites.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Favorites will appear here after you add them from the search results.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 40)
                    }
                } else {
                    List {
                        ForEach(favoritesManager.favorites) { anime in
                            NavigationLink(destination: AnimeDetailView(anime: anime)) {
                                FavoriteAnimeRow(anime: anime)
                            }
                        }
                        .onDelete(perform: removeFavorites)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    private func removeFavorites(at offsets: IndexSet) {
        for index in offsets {
            let anime = favoritesManager.favorites[index]
            favoritesManager.removeFromFavorites(anime: anime)
        }
    }
}
