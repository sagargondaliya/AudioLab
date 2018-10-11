//
//  SongListInteractor.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation
import CoreData

// MARK: - SongListInteractorDelegate

typealias SongInfo = (song: Song, indexPath: IndexPath)

/**
 This protocol will be implemented by the SongListInteractor class.
 */
protocol SongListInteractorDelegate {
    
    /// This function fetches all the songs from database
    func fetchSongs()
    
    /// This function handles the song action button event based on state
    func playPauseSong(_ song: Song)
    
    /// handle action to download song
    func downloadSong(_ song : Song)
    
    /// Get All Songs
    func getSongs() -> [Song]
}

// MARK: - SongListInteractor

/**
 The SongListInteractor class is used to perform all the business logic related to SongListViewController. It gets the data and commands from the SongListPresenter, performs the operations and revert back to it through SongListListenerDelegate.
 */
final class SongListInteractor: SongListInteractorDelegate {
    
    // MARK: - Properties
    
    /// songs
    var songs: [Song] = []
    
    /// A Listener object that holds the weak reference of SongListListenerDelegate.
    weak var listener: SongListListenerDelegate!
    
    // MARK: - SongListInteractorDelegate
    
    /// Get list
    func fetchSongs() {
    
        /// fetch and display data initially
        fetchAndDisplayDataFromDatabase()
        
        /// show network indicator if no data present in database.
        if DataBaseManager.shared.fetchObjects(entity: Song.self).count == 0 {
            // show loading indicator
        }
        
        /// fetch new data from server
        NetworkManager.shared.request(NetworkURLs.fetchSongs, method: HTTPMethod.get, parameters: nil, headers: nil, success: { (data) in
            
            /// convert to dictionary
            guard let result = data as? ResponseData else { return }
            
            /// convert data into Song models
            if let dataArray = result[ResponseKey.data] as? ResponseArray {
                
                /// save in database
                self.saveSongsToDatabase(dataArray as! [[String : AnyObject]])
            
                /// refresh data in UI
                self.fetchAndDisplayDataFromDatabase()
            }
            
        }) { (errorMessage) in
            
            /// handle error message
            self.listener.handleErrorWithMessage(errorMessage)
            print(errorMessage)
        }
    }
    
    /// get songs
    func getSongs() -> [Song] {
        return self.songs
    }
    
    /// play pause song
    func playPauseSong(_ song: Song) {
        AudioPlayerManager.shared.playPauseAudio(song)
    }
    
    /// download song
    func downloadSong(_ song: Song) {
        
        /// update download state to start
        song.downloadState = .started
        
        /// call listener
        self.listener.updateCellOnDownloadStart(song, atIndexPath: IndexPath(row: indexForSong(song.id!), section: 0))
        
        /// start download
        DownloadManager.shared.downloadFile(song.audioURL!, fileName: song.name!, identifier: song.id!, progress: { (progress, downloadedBytes, songId) in
            
            /// update progress
            let info = self.getSongInfoById(songId)
            info.song.currentProgress = progress
            info.song.totalDownloadsBytes = downloadedBytes
            self.listener.updateDownloadProgess(progress, withSongInfo: info)
            
        }, remainingTime: { (time) in
            
        }, completed: { (fileName, songId) in
            
            /// get info
            let info = self.getSongInfoById(songId)
            info.song.fileName = fileName
            info.song.downloadState = .done
            
            /// update cell UI
            self.listener.updateCellOnDownloadComplete(info.song, atIndexPath: info.indexPath)
            
            /// download completed save details to db
            DataBaseManager.shared.updateSongDetails(info.song)
            
        }, error: { (error) in
            print(error)
        })
    }
}

// MARK: - Private
extension SongListInteractor {
    
    /// This method gets data from database and show them in UI
    private func fetchAndDisplayDataFromDatabase() {
        
        /// get songs - sorted by ids of songs
        let sortDescriptor = NSSortDescriptor(key: ResponseKey.id, ascending: true)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.songs = DataBaseManager.shared.fetchObjects(entity: Song.self, predicate: nil, sortDescriptors: [sortDescriptor])
            
            for song in self.songs {
                song.downloadState = song.downloadCompleted ? .done : .none
            }
            
            DispatchQueue.main.async {
                /// show data from database
                self.listener.didGetSongs()
            }
        }
    }
    
    /// save newly added songs to database
    private func saveSongsToDatabase(_ dataArray: [[String: AnyObject]]) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
           
            /// fetch songs from db
            let dbRecords = DataBaseManager.shared.fetchObjects(entity: Song.self)
            
            /// create songs models
            var songsArray = [Song]()
            let context = DataBaseManager.shared.context
            
            dataArray.forEach({ (dict) in
                songsArray.append(Song(dictionary: dict))
            })
            
            /// remove duplicates
            dbRecords.forEach { (song) in
                if let songExists = songsArray.first(where: { $0.id == song.id }) {
                    context.delete(songExists)
                }
            }
            
            /// save to database
            DataBaseManager.shared.saveContext()
        }
    }
    
    /// Get Song info by Id
    private func getSongInfoById(_ id: String) -> SongInfo {
        
        let indexPath = IndexPath(row: self.indexForSong(id), section: 0)
        let song = self.songs[indexPath.row]
        return (song, indexPath)
    }
    
    /// get indexPath for song
    private func indexForSong(_ songId: String) -> Int {
        return self.songs.index(where: { $0.id == songId })!
    }
}
