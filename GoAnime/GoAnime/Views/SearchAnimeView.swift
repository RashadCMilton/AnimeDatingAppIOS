//
//  SearchAnimeView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import SwiftUI

struct SearchAnimeView: View {
    @State private var searchText: String = ""
    @StateObject private var vm = AnimeViewModel(animeRepository: DefaultAnimeRepository(apiService: APIService()))
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar.padding(.top, 8)
                contentView
            }
            .navigationTitle("GoAnime")
        }
    }
    
    private var searchBar: some View {
        HStack {
            TextField("Search for Anime", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await vm.fetchAnimeSearchResults(query: searchText)
                }
            }) {
                Text("Search")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.trailing)
        }
        .padding(.top, 10)
    }
    
    private var contentView: some View {
        Group {
            switch vm.viewState {
            case .loading:
                Spacer()
                LoadingStateView()
                Spacer()
            case .loaded:
                if vm.searchResults.isEmpty {
                    Text("No results found")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    animeList()
                }
            case .error:
                VStack {
                    ErrorView(message: vm.errorMessage)
                    Button("Try Again") {
                        Task {
                            await vm.fetchAnimeSearchResults(query: searchText)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    func animeList() -> some View {
        List(vm.searchResults) { anime in
            NavigationLink(destination: AnimeDetailView(anime: anime)) {
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
                        
                        if let englishTitle = anime.titleEnglish, !englishTitle.isEmpty {
                            Text(englishTitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
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
    }
}

struct Grid<Content: View>: View {
    let alignment: HorizontalAlignment
    let horizontalSpacing: CGFloat?
    let verticalSpacing: CGFloat?
    let content: () -> Content
    
    init(
        alignment: HorizontalAlignment = .center,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: verticalSpacing) {
            content()
        }
    }
}

struct GridRow<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 4) {
            content()
        }
    }
}

#Preview {
    SearchAnimeView()
}
