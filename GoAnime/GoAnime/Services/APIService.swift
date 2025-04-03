//
//  APIService.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingFailed
    case networkingFailed
}

struct Endpoint {
    static let url = "https://api.jikan.moe/v4"
    static let animePath = "/anime"
}

protocol Networking {
    func fetchData<T: Decodable>(url: URL?) async throws -> T
    func createURL(baseURL: String, path: String, queryParams: [String:String]?) throws -> URL
}

class APIService: Networking {
    func fetchData<T>(url: URL?) async throws -> T where T : Decodable {
        guard let validUrl = url else {
            throw APIError.invalidURL
        }
        
        print("Fetching from URL: \(validUrl)")
        
        let (data, response) = try await URLSession.shared.data(from: validUrl)
        
        guard let response = response as? HTTPURLResponse, isValidResponse(response: response) else {
            throw APIError.networkingFailed
        }
        
        // Print a sample of the response for debugging
        if let jsonString = String(data: data.prefix(1000), encoding: .utf8) {
            print("Sample of response: \(jsonString)...")
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            print("Decoding error details: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key not found: \(key), context: \(context)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch: \(type), context: \(context)")
                case .valueNotFound(let type, let context):
                    print("Value not found: \(type), context: \(context)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
            throw APIError.decodingFailed
        }
    }
    
    func isValidResponse(response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200..<300:
            return true
        default:
            print("Invalid response status code: \(response.statusCode)")
            return false
        }
    }
    
    func createURL(baseURL: String, path: String, queryParams: [String:String]?) throws -> URL {
        guard let validatedURL = URL(string: baseURL),
              validatedURL.scheme != nil,
              validatedURL.host != nil else {
            throw APIError.invalidURL
        }
        guard var components = URLComponents(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        components.path += path
        
        if let queryParams = queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        print("Created URL: \(url.absoluteString)")
        return url
    }
}
