//
//  AnimeRepository.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/25/25.
//


import Foundation

protocol AnimeRepository {
    func searchAnime(query: String) async throws -> [AnimeData]
    func fetchTopAnime(limit: Int) async throws -> [AnimeData]
    func fetchAiringAnime(limit: Int) async throws -> [AnimeData]
    func fetchUpcomingAnime(limit: Int) async throws -> [AnimeData]
}

class DefaultAnimeRepository: AnimeRepository {
    private let apiService: Networking
    
    init(apiService: Networking) {
        self.apiService = apiService
    }
    
    func searchAnime(query: String) async throws -> [AnimeData] {
        let queryParams: [String: String] = ["q": query]
        let url = try apiService.createURL(baseURL: Endpoint.url, path: Endpoint.animePath, queryParams: queryParams)
        let response: AnimeResponse = try await apiService.fetchData(url: url)
        return response.data
    }
    
    func fetchTopAnime(limit: Int = 10) async throws -> [AnimeData] {
        let queryParams = ["limit": "\(limit)", "order_by": "score", "sort": "desc"]
        let url = try apiService.createURL(baseURL: Endpoint.url, path: Endpoint.animePath, queryParams: queryParams)
        let response: AnimeResponse = try await apiService.fetchData(url: url)
        return response.data
    }
    
    func fetchAiringAnime(limit: Int = 10) async throws -> [AnimeData] {
        let queryParams = ["limit": "\(limit)", "status": "airing"]
        let url = try apiService.createURL(baseURL: Endpoint.url, path: Endpoint.animePath, queryParams: queryParams)
        let response: AnimeResponse = try await apiService.fetchData(url: url)
        return response.data
    }
    
    func fetchUpcomingAnime(limit: Int = 10) async throws -> [AnimeData] {
        let queryParams = ["limit": "\(limit)", "status": "upcoming"]
        let url = try apiService.createURL(baseURL: Endpoint.url, path: Endpoint.animePath, queryParams: queryParams)
        let response: AnimeResponse = try await apiService.fetchData(url: url)
        return response.data
    }
}
