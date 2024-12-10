import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playlists: [Playlist] = []  // Array to store playlists
    private let authManager = SpotifyAuthManager()  // Instance of SpotifyAuthManager


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var goToProfileButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()

               // Set up the table view
               tableView.delegate = self
               tableView.dataSource = self

               // Register the default UITableViewCell
               tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaylistCell")

        // Fetch playlists
              fetchPlaylists()
          }

          func fetchPlaylists() {
              // Get the access token using SpotifyAuthManager
              if let accessToken = authManager.getAccessToken() {
                  // Use the existing access token if it's available
                  loadPlaylists(withAccessToken: accessToken)
              } else {
                  // If no access token is found, refresh the token
                  authManager.refreshAccessToken { success in
                      if success, let newAccessToken = self.authManager.getAccessToken() {
                          // If token refresh is successful, load the playlists with the new access token
                          self.loadPlaylists(withAccessToken: newAccessToken)
                      } else {
                          print("Failed to refresh access token")
                      }
                  }
              }
          }
          
          func loadPlaylists(withAccessToken accessToken: String) {
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
                      let decodedResponse = try JSONDecoder().decode(PlaylistsResponse.self, from: data)
                      self.playlists = decodedResponse.items
                      DispatchQueue.main.async {
                          self.tableView.reloadData()
                      }
                  } catch {
                      print("Error decoding playlists: \(error)")
                  }
              }
              
              task.resume()
          }
          
          // Table View Data Source Methods
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return playlists.count
          }

          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)

              let playlist = playlists[indexPath.row]
              cell.textLabel?.text = playlist.name

              if let imageUrlString = playlist.images.first?.url, let imageUrl = URL(string: imageUrlString) {
                  let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                      if let data = data, let image = UIImage(data: data) {
                          DispatchQueue.main.async {
                              cell.imageView?.image = image
                              cell.setNeedsLayout()
                          }
                      }
                  }
                  task.resume()
              }

              return cell
          }

          // Table View Delegate Method to handle row selection
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              let selectedPlaylist = playlists[indexPath.row]
              
              if let playlistDetailsVC = storyboard?.instantiateViewController(withIdentifier: "PlaylistDetailsViewController") as? PlaylistDetailsViewController {
                  playlistDetailsVC.playlistName = selectedPlaylist.name
                  playlistDetailsVC.playlistImageURL = selectedPlaylist.images.first?.url ?? ""
                  playlistDetailsVC.playlistOwner = selectedPlaylist.owner.display_name
                  playlistDetailsVC.trackCount = selectedPlaylist.tracks.total
                  playlistDetailsVC.playlistId = selectedPlaylist.id

                  navigationController?.pushViewController(playlistDetailsVC, animated: true)
              }
          }
          
    @IBAction func goToProfileButtonTapped(_ sender: UIButton) {
        
        // Instantiate ProfileViewController from the storyboard
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            // Push ProfileViewController onto the navigation stack
          //  navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
       }
