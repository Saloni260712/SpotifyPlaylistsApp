import Foundation

// Playlist Response Model for fetching playlists
struct PlaylistsResponse: Codable {
    let items: [Playlist]
}

// Playlist Model
struct Playlist: Codable {
    let name: String
    let id: String
    let images: [Image]
    let owner: Owner
    let description: String?
    let tracks: Tracks
}

// Playlist Details (Tracks List) Response Model
struct PlaylistDetails: Decodable {
    let items: [PlaylistItem]
}

// Playlist Item Model (Each item contains a "track" object)
struct PlaylistItem: Decodable {
    let track: Track  // Each item contains a "track" object
}

// Track Model for Playlist
struct Track: Codable {
    let name: String?
    let artists: [Artist]
    let album: Album?
    let preview_url: String?

    struct Artist: Codable {
        let name: String?
    }

    struct Album: Codable {
        let name: String?
    }
}


// Image Model for user and playlist images
struct Image: Codable {
    let url: String
}

// Album Model for Track (not used in your view but may be useful)
struct Album: Codable {
    let name: String
    let images: [Image]
}

// Tracks Model for playlist
struct Tracks: Codable {
    let total: Int
}

// User Profile Model
struct UserProfile: Codable {
    let display_name: String
    let followers: Followers
    let images: [Image]
}

// Followers Model for user
struct Followers: Codable {
    let total: Int
}

// Owner Model for playlist
struct Owner: Codable {
    let display_name: String
}

// Error Model for API Responses
struct SpotifyErrorResponse: Codable {
    let error: SpotifyAPIError
}

struct SpotifyAPIError: Codable {
    let status: Int
    let message: String
}

struct TrackResponse: Decodable {
    let items: [Track]
}
