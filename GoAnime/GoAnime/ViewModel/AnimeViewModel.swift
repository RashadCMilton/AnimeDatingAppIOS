//
//  AnimeViewModel.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import Foundation
import SwiftUI

enum ViewStates {
    case loading
    case loaded
    case error(Error)
}

class AnimeViewModel: ObservableObject {
    @Published var viewState: ViewStates = .loading
    @Published var searchResults: [AnimeData] = []
    @Published var errorMessage: String = ""
    
    private let animeRepository: AnimeRepository
    
    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }
    
    @MainActor
    func fetchAnimeSearchResults(query: String) async {
        // Don't search if query is empty
        guard !query.isEmpty else {
            self.errorMessage = "Please enter a search term"
            self.viewState = .error(NSError(domain: "GoAnime", code: 0, userInfo: [NSLocalizedDescriptionKey: "Search query is empty"]))
            return
        }
        
        // Set viewState to loading before fetching
        viewState = .loading
        
        do {
            // Fetch data from repository
            searchResults = try await animeRepository.searchAnime(query: query)
            
            // Set viewState to loaded once the data is fetched
            viewState = .loaded
            
        } catch let error as APIError {
            // Handle API specific errors
            switch error {
            case .invalidURL:
                errorMessage = "Invalid URL. Please try again."
            case .decodingFailed:
                errorMessage = "Could not process the server response."
            case .networkingFailed:
                errorMessage = "Network error. Please check your connection."
            }
            viewState = .error(error)
            
        } catch {
            // Handle other errors
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            viewState = .error(error)
        }
    }
}
