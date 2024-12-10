import UIKit
import AVFoundation
import AVKit

class PlaylistDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playlistName: String = ""
    var playlistImageURL: String = ""
    var playlistOwner: String = ""
    var playlistId: String = ""  // Add playlistId property
    var trackCount: Int = 0
    var tracks: [Track] = [] // Array to store the tracks

    let authManager = SpotifyAuthManager() // SpotifyAuthManager instance


    
    // UI Elements
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var playlistImageView: UIImageView!
    
    @IBOutlet weak var playlistOwnerLabel: UILabel!
    
    @IBOutlet weak var trackCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the playlist name and other details
                playlistNameLabel.text = playlistName
                playlistOwnerLabel.text = "Owner: \(playlistOwner)"
                trackCountLabel.text = "Tracks: \(trackCount)"
                
                // Load and display the playlist image
                if let imageURL = URL(string: playlistImageURL) {
                    loadImage(from: imageURL)
                }
                
                // Fetch the tracks for the playlist
                fetchTracks(forPlaylist: playlistId)
            }
            
            func loadImage(from url: URL) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.playlistImageView.image = image
                        }
                    }
                }
                task.resume()
            }
            
            // Fetch tracks for the playlist from Spotify API
            func fetchTracks(forPlaylist playlistId: String) {
                // Get access token using SpotifyAuthManager
                if let accessToken = authManager.getAccessToken() {
                    let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)/tracks")!
                    var request = URLRequest(url: url)
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error fetching tracks: \(error)")
                            return
                        }

                        guard let data = data else {
                            print("No data received")
                            return
                        }

                        // Print raw response for debugging
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Raw JSON Response: \(jsonString)")
                        }

                        do {
                            let decodedResponse = try JSONDecoder().decode(PlaylistDetails.self, from: data)
                            self.tracks = decodedResponse.items.map { $0.track }

                            // Debugging: print the tracks to verify decoding
                            print("Decoded Tracks: \(self.tracks)")

                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } catch {
                            print("Error decoding tracks data: \(error)")
                        }
                    }

                    task.resume()
                } else {
                    // If no access token, attempt to refresh it
                    authManager.refreshAccessToken { success in
                        if success, let newAccessToken = self.authManager.getAccessToken() {
                            self.fetchTracks(forPlaylist: playlistId)
                        } else {
                            print("Failed to refresh access token")
                        }
                    }
                }
            }

            // UITableView DataSource Methods
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return tracks.count
            }

            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
                
                // Get the track at the current index
                let track = tracks[indexPath.row]
                
                // Configure the cell
                cell.textLabel?.text = track.name ?? "Unknown Track"
                
                // Get the artist names, join them by commas if there are multiple
                let artistNames = track.artists.compactMap { $0.name }.joined(separator: ", ")
                cell.detailTextLabel?.text = artistNames.isEmpty ? "Unknown Artist" : artistNames
                
                return cell
            }

            // UITableView Delegate Method for playing selected track
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let selectedTrack = tracks[indexPath.row]

                   // Create an instance of TrackDetailViewController and pass the track data
                if let trackDetailVC = storyboard?.instantiateViewController(withIdentifier: "TrackDetailViewController") as? TrackDetailViewController {
                    trackDetailVC.track = selectedTrack  // Pass the selected track
                    
                    // Present the TrackDetailViewController modally
                    present(trackDetailVC, animated: true, completion: nil)}
            }
    

           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showTrackDetail" {
               if let indexPath = tableView.indexPathForSelectedRow {
                   let selectedTrack = tracks[indexPath.row]
                   let trackDetailVC = segue.destination as! TrackDetailViewController
                   trackDetailVC.track = selectedTrack  // Pass the selected track
               }
           }
       }
   }
