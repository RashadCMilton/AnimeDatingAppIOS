//
//  GoAnimeTests.swift
//  GoAnimeTests
//
//  Created by Rashad Milton on 3/21/25.
//

import XCTest
import Firebase
import CoreData
@testable import GoAnime

final class GoAnimeTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - APIService Tests
    func testAPIServiceValidURL() throws {
        let apiService = APIService()
        
        let baseURL = "https://api.jikan.moe/v4"
        let path = "/anime"
        let queryParams = ["q": "naruto", "limit": "10"]
        
        XCTAssertNoThrow(try apiService.createURL(baseURL: baseURL, path: path, queryParams: queryParams))
    }
    
    func testAPIServiceInvalidURL() {
        let apiService = APIService()
        
        XCTAssertThrowsError(try apiService.createURL(baseURL: "invalid url", path: "", queryParams: nil)) { error in
            XCTAssertTrue(error is APIError)
            XCTAssertEqual(error as? APIError, .invalidURL)
        }
    }
    
    func testDefaultAnimeRepositorySearch() async throws {
        let mockNetworking = MockNetworking()
        let mockResponse = AnimeResponse(
            data: [
                AnimeData(malID: 1, url: "", images: Images(jpg: ImageInfo(imageURL: "", smallImageURL: nil, largeImageURL: ""), webp: nil, largeImageURL: nil), trailer: Trailer(youtubeID: nil, url: nil, embedURL: nil, images: nil), approved: true, titles: [], title: "Naruto", titleEnglish: nil, titleJapanese: nil, titleSynonyms: [], type: nil, source: nil, episodes: nil, status: nil, airing: false, aired: Aired(from: nil, to: nil, prop: Prop(from: nil, to: nil), string: nil), duration: nil, rating: nil, score: nil, scoredBy: nil, rank: nil, popularity: nil, members: nil, favorites: nil, synopsis: nil, background: nil, season: nil, year: nil, broadcast: nil, producers: nil, licensors: nil, studios: nil, genres: nil, explicitGenres: nil, themes: nil, demographics: nil)
            ],
            pagination: Pagination(lastVisiblePage: 1, hasNextPage: false, currentPage: 1, items: Items(count: 1, total: 1, perPage: 1))
        )
        mockNetworking.mockFetchResult = mockResponse
        
        let repository = DefaultAnimeRepository(apiService: mockNetworking as Networking)
        
        let results = try await repository.searchAnime(query: "naruto")
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Naruto")
    }
    
    // MARK: - HomeViewModel Tests
    func testHomeViewModel() async {
        let mockRepository = MockAnimeRepository()
        let viewModel = HomeViewModel(animeRepository: mockRepository)
        
        await viewModel.fetchAllData()
        
        XCTAssertEqual(viewModel.topAnime.count, 15)
        XCTAssertEqual(viewModel.airingAnime.count, 15)
        XCTAssertEqual(viewModel.upcomingAnime.count, 15)
        XCTAssertFalse(viewModel.hasError)
    }
    
    class MockAnimeRepository: AnimeRepository {
        func searchAnime(query: String) async throws -> [AnimeData] {
            return []
        }
        
        func fetchTopAnime(limit: Int) async throws -> [AnimeData] {
            return Array(repeating: createMockAnimeData(), count: 15)
        }
        
        func fetchAiringAnime(limit: Int) async throws -> [AnimeData] {
            return Array(repeating: createMockAnimeData(), count: 15)
        }
        
        func fetchUpcomingAnime(limit: Int) async throws -> [AnimeData] {
            return Array(repeating: createMockAnimeData(), count: 15)
        }
        
        private func createMockAnimeData() -> AnimeData {
            return AnimeData(
                malID: 1,
                url: "https://example.com",
                images: Images(
                    jpg: ImageInfo(imageURL: "", smallImageURL: nil, largeImageURL: ""),
                    webp: nil,
                    largeImageURL: nil
                ),
                trailer: Trailer(youtubeID: nil, url: nil, embedURL: nil, images: nil),
                approved: true,
                titles: [],
                title: "Mock Anime",
                titleEnglish: nil,
                titleJapanese: nil,
                titleSynonyms: [],
                type: nil,
                source: nil,
                episodes: nil,
                status: nil,
                airing: false,
                aired: Aired(from: nil, to: nil, prop: Prop(from: nil, to: nil), string: nil),
                duration: nil,
                rating: nil,
                score: nil,
                scoredBy: nil,
                rank: nil,
                popularity: nil,
                members: nil,
                favorites: nil,
                synopsis: nil,
                background: nil,
                season: nil,
                year: nil,
                broadcast: nil,
                producers: nil,
                licensors: nil,
                studios: nil,
                genres: nil,
                explicitGenres: nil,
                themes: nil,
                demographics: nil
            )
        }
    }
    
    // MARK: - FavoritesManager Tests
    func testFavoritesManagerAddRemoveFavorite() {
        let favoritesManager = FavoritesManager()
        
        let mockAnime = createMockAnimeData()
        
        XCTAssertFalse(favoritesManager.isFavorite(anime: mockAnime))
        
        favoritesManager.addToFavorites(anime: mockAnime)
        XCTAssertTrue(favoritesManager.isFavorite(anime: mockAnime))
        
        favoritesManager.removeFromFavorites(anime: mockAnime)
        XCTAssertFalse(favoritesManager.isFavorite(anime: mockAnime))
    }
    
    
    // Helper method for creating mock AnimeData
    private func createMockAnimeData() -> AnimeData {
        return AnimeData(
            malID: 1,
            url: "https://example.com",
            images: Images(
                jpg: ImageInfo(imageURL: "", smallImageURL: nil, largeImageURL: ""),
                webp: nil,
                largeImageURL: nil
            ),
            trailer: Trailer(youtubeID: nil, url: nil, embedURL: nil, images: nil),
            approved: true,
            titles: [],
            title: "Mock Anime",
            titleEnglish: nil,
            titleJapanese: nil,
            titleSynonyms: [],
            type: nil,
            source: nil,
            episodes: nil,
            status: nil,
            airing: false,
            aired: Aired(from: nil, to: nil, prop: Prop(from: nil, to: nil), string: nil),
            duration: nil,
            rating: nil,
            score: nil,
            scoredBy: nil,
            rank: nil,
            popularity: nil,
            members: nil,
            favorites: nil,
            synopsis: nil,
            background: nil,
            season: nil,
            year: nil,
            broadcast: nil,
            producers: nil,
            licensors: nil,
            studios: nil,
            genres: nil,
            explicitGenres: nil,
            themes: nil,
            demographics: nil
        )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
