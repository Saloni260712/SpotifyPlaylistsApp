# SpotifyPlaylistsApp

## Overview

**SpotifyPlaylistsApp** is an iOS application that allows users to view their Spotify playlists, explore tracks within each playlist, and view detailed information about the selected tracks. The app integrates with the Spotify API to fetch user data, playlists, and track details. It supports core features like token management, CoreData for local storage, and playback of track previews.

## Features

- **Spotify Authentication**: The app uses Spotify’s API to authenticate users and fetch their data.
- **Display Playlists**: Shows a list of playlists for the authenticated user.
- **Track Details**: Taps on a track to navigate to detailed information about the selected track.
- **CoreData Integration**: Tracks are stored locally for offline use with CoreData.
- **Auto Layout**: Fully supports landscape and portrait orientations for iPhone and iPad devices.

## Requirements

- iOS 12.0+
- Xcode 12+
- Swift 5+
- CoreData
- AVFoundation for audio playback

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/SpotifyPlaylistsApp.git

