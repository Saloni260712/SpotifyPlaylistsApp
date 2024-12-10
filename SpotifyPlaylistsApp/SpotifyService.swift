//
//  SpotifyService.swift
//  SpotifyPlaylistsApp
//
//  Created by Meet Patel on 09/12/24.
//

import Foundation

class SpotifyService {

    static let shared = SpotifyService() // Singleton instance

    private init() {}

    // Function to refresh the access token
    func refreshAccessToken(completion: @escaping (String?) -> Void) {
        // Replace with your refresh token URL and parameters
        let refreshToken = "AQDqeXsAhq8QM_AUkG_DDQurteSlD9P2KWB8GaZbUCEdcEuSTp6oQUyb7qeZ0g3vJNDNnzkHaT4bvaSt-a4QqNWOtzw2FMaHSsW9LPB8vBK5qEPxybCdGEfTjURPj1UaL8s"
        let clientID = "b5cf8ba2db094130baea3500fef3698b"
        let clientSecret = "5407dcd966ec4c4db6cd42acdb760a2c"

        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64EncodedClientIDAndSecret())", forHTTPHeaderField: "Authorization")
        let body = "grant_type=refresh_token&refresh_token=\(refreshToken)"
        request.httpBody = body.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error refreshing token: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                // Decode the response to get the new access token
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let newAccessToken = jsonResponse["access_token"] as? String {
                    completion(newAccessToken)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing response: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }

    // Helper function to create base64 encoded client ID and secret
    private func base64EncodedClientIDAndSecret() -> String {
        let clientID = "b5cf8ba2db094130baea3500fef3698b"
        let clientSecret = "5407dcd966ec4c4db6cd42acdb760a2c"
        let credentials = "\(clientID):\(clientSecret)"
        return Data(credentials.utf8).base64EncodedString()
    }
}
