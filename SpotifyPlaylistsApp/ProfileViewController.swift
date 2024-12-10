//
//  ProfileViewController.swift
//  SpotifyPlaylistsApp
//
//  Created by Meet Patel on 10/12/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
  //  var accessToken: String = "BQD86cjyvBJaX-zzy0IWVeENrQC8J-pByWLeque8rqBLazao7j1nN6avMDmQPkLoXxvULM7VWRLT8IIjrqDg_qFIyT5rxn7OnOA3Yii65VJtDnIFJDRM6H2u2lVDafKrnlkhRuHxyv-7WInh4PUTUSQU_CDIjIRSLJxMRIAqmZ82I5B_DaGA3wtED9YG8N6uGShgjaBcx1432tQ74rEE4Xpnnhs" // Replace with your actual token
    
    let authManager = SpotifyAuthManager()

    
    var userName: String = ""
       var userImageURL: String = ""
       var userFollowers: Int = 0
       var playlists: [Playlist] = [] // Array to store playlists
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var playlistsTableView: UITableView!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
               // Fetch the access token from AuthManager
               if let accessToken = authManager.getAccessToken() {
                   // If access token is available, fetch user profile and playlists
                   fetchUserProfile(accessToken: accessToken)
                   fetchUserPlaylists(accessToken: accessToken)
               } else {
                   // If there's no token, refresh the token
                   authManager.refreshAccessToken { success in
                       if success, let newAccessToken = self.authManager.getAccessToken() {
                           self.fetchUserProfile(accessToken: newAccessToken)
                           self.fetchUserPlaylists(accessToken: newAccessToken)
                       } else {
                           print("Failed to get or refresh access token")
                       }
                   }
               }
           }
           
           func fetchUserProfile(accessToken: String) {
               let url = URL(string: "https://api.spotify.com/v1/me")!
               var request = URLRequest(url: url)
               request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
               
               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   if let error = error {
                       print("Error fetching profile data: \(error)")
                       return
                   }
                   
                   guard let data = data else {
                       print("No data received")
                       return
                   }
                   
                   do {
                       let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                       DispatchQueue.main.async {
                           self.profileNameLabel.text = profile.display_name
                           self.followersLabel.text = "Followers: \(profile.followers.total)"
                           
                           if let imageUrlString = profile.images.first?.url, let imageUrl = URL(string: imageUrlString) {
                               self.loadImage(from: imageUrl)
                           }
                       }
                   } catch {
                       print("Error decoding profile data: \(error)")
                   }
               }
               
               task.resume()
           }
           
           func fetchUserPlaylists(accessToken: String) {
               let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
               var request = URLRequest(url: url)
               request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
               
               let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   if let error = error {
                       print("Error fetching playlists: \(error)")
                       return
                   }
                   
                   guard let data = data else {
                       print("No data received")
                       return
                   }
                   
                   do {
                       let playlistsResponse = try JSONDecoder().decode(PlaylistsResponse.self, from: data)
                       self.playlists = playlistsResponse.items
                       DispatchQueue.main.async {
                           self.playlistsTableView.reloadData()
                       }
                   } catch {
                       print("Error decoding playlists: \(error)")
                   }
               }
               
               task.resume()
           }

           func loadImage(from url: URL) {
               let task = URLSession.shared.dataTask(with: url) { data, response, error in
                   if let data = data, let image = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self.profileImageView.image = image
                       }
                   }
               }
               task.resume()
           }
       }
