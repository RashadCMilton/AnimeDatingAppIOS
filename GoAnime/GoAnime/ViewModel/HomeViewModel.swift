//
//  HomeViewModel.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/22/25.
//
import Foundation

class HomeViewModel: ObservableObject {
    @Published var topAnime: [AnimeData] = []
    @Published var airingAnime: [AnimeData] = []
    @Published var upcomingAnime: [AnimeData] = []
    
    @Published var isLoadingTopAnime = false
    @Published var isLoadingAiringAnime = false
    @Published var isLoadingUpcomingAnime = false
    @Published var hasError = false

    private let animeRepository: AnimeRepository
    
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }
    
    func fetchAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchTopAnime() }
            group.addTask { await self.fetchAiringAnime() }
            group.addTask { await self.fetchUpcomingAnime() }
        }
    }
    
    @MainActor
    func fetchTopAnime() async {
        isLoadingTopAnime = true
        hasError = false
        
        do {
            self.topAnime = try await animeRepository.fetchTopAnime(limit: 15)
            isLoadingTopAnime = false
        } catch {
            print("Error fetching top anime: \(error)")
            hasError = true
            isLoadingTopAnime = false
        }
    }
    
    @MainActor
    func fetchAiringAnime() async {
        isLoadingAiringAnime = true
        hasError = false
        
        do {
            self.airingAnime = try await animeRepository.fetchAiringAnime(limit: 15)
            isLoadingAiringAnime = false
        } catch {
            print("Error fetching airing anime: \(error)")
            hasError = true
            isLoadingAiringAnime = false
        }
    }
    
    @MainActor
    func fetchUpcomingAnime() async {
        isLoadingUpcomingAnime = true
        hasError = false
        
        do {
            self.upcomingAnime = try await animeRepository.fetchUpcomingAnime(limit: 15)
            isLoadingUpcomingAnime = false
        } catch {
            print("Error fetching upcoming anime: \(error)")
            hasError = true
            isLoadingUpcomingAnime = false
        }
    }
}
