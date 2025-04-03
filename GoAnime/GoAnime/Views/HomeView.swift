//
//  HomeView.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(animeRepository: DefaultAnimeRepository(apiService: APIService()))
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Error message if needed
                    if viewModel.hasError {
                        ErrorView(message: "Unable to load anime data. Pull down to refresh.")
                    }
                    
                    // Top Anime Section
                    AnimeSection(
                        title: "Top Anime",
                        anime: viewModel.topAnime,
                        isLoading: viewModel.isLoadingTopAnime
                    )
                    
                    // Airing Anime Section
                    AnimeSection(
                        title: "Currently Airing",
                        anime: viewModel.airingAnime,
                        isLoading: viewModel.isLoadingAiringAnime
                    )
                    
                    // Upcoming Anime Section
                    AnimeSection(
                        title: "Upcoming Anime",
                        anime: viewModel.upcomingAnime,
                        isLoading: viewModel.isLoadingUpcomingAnime
                    )
                }
                .padding()
            }
            .refreshable {
                await viewModel.fetchAllData()
            }
            .navigationTitle("GoAnime")
            .onAppear {
                Task {
                    await viewModel.fetchAllData()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
