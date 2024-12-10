//
//  TrackDetailViewController.swift
//  SpotifyPlaylistsApp
//
//  Created by Meet Patel on 10/12/24.
//

import UIKit
import AVFoundation
import AVKit

class TrackDetailViewController: UIViewController {
    var track: Track?  // Declare track property to hold the track data

    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var previewButton: UIButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        // Display track information
              if let track = track {
                  trackNameLabel.text = track.name
                  artistLabel.text = track.artists.compactMap { $0.name }.joined(separator: ", ")
                  albumNameLabel.text = track.album?.name
              }
    }
    
    
    @IBAction func playPreview(_ sender: UIButton) {
        
        if let previewURL = track?.preview_url {
                   playTrack(from: previewURL)
               }
    }
    
    func playTrack(from urlString: String) {
            if let url = URL(string: urlString) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
