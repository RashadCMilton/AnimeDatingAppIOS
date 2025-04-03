//
//  MockNetworking.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/25/25.
//

@testable import GoAnime
import Foundation

// MARK: - AnimeRepository Tests
class MockNetworking: Networking {
    var mockFetchResult: Decodable?
    var shouldThrowError = false
    
    func fetchData<T>(url: URL?) async throws -> T where T : Decodable {
        if shouldThrowError {
            throw APIError.networkingFailed
        }
        guard let result = mockFetchResult as? T else {
            throw APIError.decodingFailed
        }
        return result
    }
    
    func createURL(baseURL: String, path: String, queryParams: [String : String]?) throws -> URL {
        return URL(string: "https://test.com")!
    }
}
