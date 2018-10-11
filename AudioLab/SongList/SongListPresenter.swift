//
//  SongListPresenter.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation

// MARK:- Protocols

/**
 This protocol will be implemeted by SongListPresenter class. This protocol contains the methods related to receive inputs from the SongListViewController.
 */
protocol SongListPresenterDelegate: class {
    
    /// This function gets all the Songs
    func getSongs()
    
    /// Handle button action for song
    func handleButtonActionForSong(_ song : Song)
    
    /// Get Songs List
    func getSongList() -> [Song]
}


/**
 This protocol will be implemented by the SongListPresenter class. This protocol contains the methods related to receive inputs from the SongListInteractor.
 */
protocol SongListListenerDelegate: class {
    
    /// This function is use to show songs after fetched from database
    func didGetSongs()
    
    /// Handle error conition
    func handleErrorWithMessage(_ message : String)
    
    /// Update Cell UI on Downalod Start
    func updateCellOnDownloadStart(_ song: Song, atIndexPath indexPath: IndexPath)
    
    /// Update cell progress
    func updateDownloadProgess(_ progress: Float, withSongInfo info: SongInfo)
    
    /// Update UI on song download completed
    func updateCellOnDownloadComplete(_ song: Song,  atIndexPath indexPath: IndexPath)
    
}

// MARK: - SongListPresenter

/**
 The SongListPresenter object will be used as communication layer between the SongListViewController and SongListInterector.
 */
final class SongListPresenter: SongListPresenterDelegate {
    
    // MARK: - Properties
    
    /// An interactor object that holds the reference of SongListInteractorDelegate.
    var interactor: SongListInteractorDelegate!
    
    /// A viewDelegate object that holds the weak reference of SongListViewDelegate.
    weak var viewDelegate: SongListViewDelegate!
    
    // MARK: - SongListPresenterDelegate
    
    /// fetch songs
    func getSongs() {
        self.interactor.fetchSongs()
    }
    
    /// action handler
    func handleButtonActionForSong(_ song: Song) {
        
        //If song is already downloaded
        if song.downloadState == .done {
            
            //handle play action for already downaloaded song
            self.interactor.playPauseSong(song)
            
            //reload table
            self.viewDelegate.reloadTableView()
            return
        }
        
        //handle donwload action
        self.interactor.downloadSong(song)
    }
    
    /// get song list
    func getSongList() -> [Song] {
        return self.interactor.getSongs()
    }
}

// MARK: SongListListenerDelegate

extension SongListPresenter: SongListListenerDelegate {
    
    /// songs received
    func didGetSongs() {
        self.viewDelegate.showSongList()
    }
    
    /// update cell when download start
    func updateCellOnDownloadStart(_ song: Song, atIndexPath indexPath: IndexPath) {
        self.viewDelegate.updateCellOnDownloadStart(song, atIndexPath: indexPath)
    }
    
    /// update downaload progress
    func updateDownloadProgess(_ progress: Float, withSongInfo info: SongInfo) {
        self.viewDelegate.updateDownloadProgess(progress, withSongInfo: info)
    }
    
    /// update cell when download completes
    func updateCellOnDownloadComplete(_ song: Song, atIndexPath indexPath: IndexPath) {
        self.viewDelegate.updateCellOnDownloadComplete(song, atIndexPath: indexPath)
    }
    
    /// handle error alert message
    func handleErrorWithMessage(_ message: String) {
        self.viewDelegate.showAlertWithMessage(message)
    }
}
