//
//  AnimeModels.swift
//  GoAnime
//
//  Created by Rashad Milton on 3/21/25.
//

import Foundation

// MARK: - AnimeResponse
struct AnimeResponse: Codable {
    let data: [AnimeData]
    let pagination: Pagination
}

// MARK: - AnimeData
struct AnimeData: Codable, Identifiable, Equatable {
    let malID: Int
    let url: String
    let images: Images
    let trailer: Trailer
    let approved: Bool
    let titles: [Title]
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let titleSynonyms: [String]
    let type: String?
    let source: String?
    let episodes: Int?
    let status: String?
    let airing: Bool
    let aired: Aired
    let duration: String?
    let rating: String?
    let score: Double?
    let scoredBy: Int?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorites: Int?
    let synopsis: String?
    let background: String?
    let season: String?
    let year: Int?
    let broadcast: Broadcast?
    let producers: [Demographic]?
    let licensors: [Demographic]?
    let studios: [Demographic]?
    let genres: [Demographic]?
    let explicitGenres: [Demographic]?
    let themes: [Demographic]?
    let demographics: [Demographic]?
    
    var id: Int {
        return malID
    }

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, images, trailer, approved, titles, title
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case titleSynonyms = "title_synonyms"
        case type, source, episodes, status, airing, aired, duration, rating, score
        case scoredBy = "scored_by"
        case rank, popularity, members, favorites, synopsis, background, season, year, broadcast, producers, licensors, studios, genres
        case explicitGenres = "explicit_genres"
        case themes, demographics
    }
    
    // Add Equatable conformance
    static func == (lhs: AnimeData, rhs: AnimeData) -> Bool {
        // Compare by malID which should be unique for each anime
        return lhs.malID == rhs.malID
    }
}

// MARK: - Aired
struct Aired: Codable {
    let from: String?
    let to: String?
    let prop: Prop
    let string: String?
}

// MARK: - Prop
struct Prop: Codable {
    let from: FromTo?
    let to: FromTo?
}

// MARK: - FromTo
struct FromTo: Codable {
    let day: Int?
    let month: Int?
    let year: Int?
}

// MARK: - Broadcast
struct Broadcast: Codable {
    let day: String?
    let time: String?
    let timezone: String?
    let string: String?
}

// MARK: - Demographic
struct Demographic: Codable {
    let malID: Int
    let type: String
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type, name, url
    }
}

// MARK: - Images
struct Images: Codable {
    let jpg: ImageInfo
    let webp: ImageInfo?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case jpg, webp
        case largeImageURL = "large_image_url"
    }
}

// MARK: - ImageInfo
struct ImageInfo: Codable {
    let imageURL: String
    let smallImageURL: String?
    let largeImageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
    }
}

// MARK: - Title
struct Title: Codable {
    let type: String
    let title: String
}

// MARK: - Trailer
struct Trailer: Codable {
    let youtubeID: String?
    let url: String?
    let embedURL: String?
    let images: TrailerImages?

    enum CodingKeys: String, CodingKey {
        case youtubeID = "youtube_id"
        case url
        case embedURL = "embed_url"
        case images
    }
}

// MARK: - TrailerImages
struct TrailerImages: Codable {
    let imageURL: String?
    let smallImageURL: String?
    let mediumImageURL: String?
    let largeImageURL: String?
    let maximumImageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case mediumImageURL = "medium_image_url"
        case largeImageURL = "large_image_url"
        case maximumImageURL = "maximum_image_url"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let lastVisiblePage: Int
    let hasNextPage: Bool
    let currentPage: Int?
    let items: Items

    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case currentPage = "current_page"
        case items
    }
}

// MARK: - Items
struct Items: Codable {
    let count: Int
    let total: Int
    let perPage: Int

    enum CodingKeys: String, CodingKey {
        case count, total
        case perPage = "per_page"
    }
}
