//
//  AnimeDetailView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import SwiftUI

struct AnimeDetailView: View {
    let anime: AnimeData
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with image
                headerView
                
                // Favorite button
                favoriteButton
                
                // Synopsis
                if let synopsis = anime.synopsis, !synopsis.isEmpty {
                    sectionView(title: "Synopsis") {
                        Text(synopsis)
                    }
                }
                
                // Info section
                sectionView(title: "Information") {
                    infoGrid
                }
                
                // Genres
                if let genres = anime.genres, !genres.isEmpty {
                    sectionView(title: "Genres") {
                        tagsView(items: genres)
                    }
                }
                
                // External link
                Link(destination: URL(string: anime.url)!) {
                    HStack {
                        Text("View on MyAnimeList")
                        Image(systemName: "arrow.up.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(anime.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Components
    
    private var headerView: some View {
        VStack(spacing: 8) {
            // Anime image
            if let imageURL = URL(string: anime.images.jpg.largeImageURL) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(height: 200)
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit)
                            .frame(height: 200).cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo").frame(height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.horizontal)
            }
            
            // Title and score
            VStack(alignment: .leading) {
                Text(anime.title).font(.title3).fontWeight(.bold)
                
                if let titleJapanese = anime.titleJapanese, !titleJapanese.isEmpty {
                    Text(titleJapanese).font(.subheadline).foregroundColor(.secondary)
                }
                
                if let score = anime.score {
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.yellow)
                        Text("\(score, specifier: "%.1f")")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var favoriteButton: some View {
        Button(action: {
            favoritesManager.toggleFavorite(anime: anime)
        }) {
            HStack {
                Image(systemName: favoritesManager.isFavorite(anime: anime) ? "heart.fill" : "heart")
                Text(favoritesManager.isFavorite(anime: anime) ? "Remove from Favorites" : "Add to Favorites")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
    
    private var infoGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            infoRow(label: "Type", value: anime.type ?? "Unknown")
            
            if let episodes = anime.episodes {
                infoRow(label: "Episodes", value: "\(episodes)")
            }
            
            infoRow(label: "Status", value: anime.status ?? "Unknown")
            
            if let season = anime.season, let year = anime.year {
                infoRow(label: "Released", value: "\(season.capitalized) \(year)")
            }
            
            if let rating = anime.rating, !rating.isEmpty {
                infoRow(label: "Rating", value: rating)
            }
            
            if let studios = anime.studios, !studios.isEmpty {
                infoRow(label: "Studio", value: studios.first?.name ?? "")
            }
        }
    }
    
    private func tagsView(items: [Demographic]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.malID) { item in
                    Text(item.name)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            content()
            Divider()
        }
        .padding(.horizontal)
    }
    
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
        }
    }
}
