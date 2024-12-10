//
//  SpotifyAuthManager.swift
//  SpotifyPlaylistsApp
//
//  Created by Meet Patel on 10/12/24.
//

import Foundation

// Struct to hold the token response
struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

class SpotifyAuthManager {
    
    // Store your refresh token, client ID, and client secret securely (e.g., in Keychain)
    private let clientID = "b5cf8ba2db094130baea3500fef3698b"
    private let clientSecret = "5407dcd966ec4c4db6cd42acdb760a2c"
    private var refreshToken = "AQCbB1xbNIGOboNYZZsSl22TzxDnllzvJTtTTzwR_GUt074HtcN2QU5Nu7AYFC7yPS3AM9rUDOrhldx7bw93DVfyDvDumG8l2Ni043BhgX_uVa8iaHhL_gVagsGa1uOSe4Y"
    
    // This will store the current access token
    private var accessToken: String?
    
    // Function to refresh the access token
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the body for the request
        let bodyString = "grant_type=refresh_token&refresh_token=\(refreshToken)"
        request.httpBody = bodyString.data(using: .utf8)
        
        // Add client credentials in the header (encoded in base64)
        let credentials = "\(clientID):\(clientSecret)"
        if let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() {
            request.addValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        }
        
        // Debugging: Print out the request details
        print("Request URL: \(url)")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(bodyString)")
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error refreshing token: \(error)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            // Print the raw response data for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response from Spotify: \(responseString)")
            }
            
            // Decode the response
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                self.accessToken = tokenResponse.access_token
                
                // You may want to store the new access token in the keychain or UserDefaults
                UserDefaults.standard.set(self.accessToken, forKey: "SpotifyAccessToken")
                
                completion(true)
            } catch {
                print("Error decoding token response: \(error)")
                completion(false)
            }
        }
        
        task.resume()
    }

       
       // Function to check and get the access token
       func getAccessToken() -> String? {
           // If the access token is not expired, return the existing one
           if let token = self.accessToken {
               return token
           } else if let storedToken = UserDefaults.standard.string(forKey: "SpotifyAccessToken") {
               self.accessToken = storedToken
               return storedToken
           } else {
               return nil
           }
       }
   }
