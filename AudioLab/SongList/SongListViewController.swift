//
//  SongListViewController.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import UIKit

/**
 This protocol will be implemented by the SongListViewController class. This protocol contains method for view related operations.
 */
protocol SongListViewDelegate: class {
    
    /// This functions is called when Songs fetched from database
    func showSongList()
    
    /// Show Alert for Error
    func showAlertWithMessage(_ message: String)
    
    /// Reload tableview
    func reloadTableView()
    
    /// Update Cell UI on Downalod Start
    func updateCellOnDownloadStart(_ song: Song, atIndexPath indexPath: IndexPath)
    
    /// Update cell progress
    func updateDownloadProgess(_ progress: Float, withSongInfo info: SongInfo)
    
    /// Update UI on song download completed
    func updateCellOnDownloadComplete(_ song: Song,  atIndexPath indexPath: IndexPath)

}

/**
This class implements methods of SongListViewDelegate.
*/
final class SongListViewController: UIViewController  {
    
    // MARK: - Outlets
    @IBOutlet weak var songTableView: UITableView!
    
    // MARK: - Properties
    
    /// A presenter object that holds the reference of SongListPresenterDelegate.
    var presenter: SongListPresenterDelegate!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SongListConfigurator.shared.configure(viewcontroller: self)
        
        setupViews()
        
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notifications.AudioPlayerDidFinish, object: nil)
    }
    
    // MARK: - Public methods
    
    /// This method is used to setup views and subviews when view loads.
    func setupViews() {
        songTableView.tableFooterView = UIView()
    }
    
    // MARK: - Initialize
    func initialize() {
        self.title = Titles.songs
        
        NotificationCenter.default.addObserver(self, selector: #selector(SongListViewController.songDidFinishPlaying), name: Notifications.AudioPlayerDidFinish, object: nil)
        
        /// get Songs
        self.presenter.getSongs()
    }
}

// MARK: - Private
extension SongListViewController {
    
    /// This method returns song at specified index
    private func songAtIndex(index: Int) -> Song {
        return self.presenter.getSongList()[index]
    }
    
    /// notification handler
    @objc private func songDidFinishPlaying() {
        reloadTableView()
    }
}

// MARK: - UITableViewDataSource
extension SongListViewController: UITableViewDataSource {
    
    /// returns sections count
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// returns rows count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getSongList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.songViewCell, for: indexPath) as! SongViewCell
    
        // set song details
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            let song = self.songAtIndex(index: indexPath.row)
            
            DispatchQueue.main.async {
                cell.setSongInfo(song, atIndexPath: indexPath)
            }
        }
        
        // download button click handler
        cell.downloadClicked = { (songInfo) in
            
            // check network reachability
            if !NetworkReachability.isInternetAvailable(){
                AlertView.showAlertWithTitle(AppTitle, message: Failure.noInternetConnection, viewController: self)
                return
            }
            
            // handle click action
            self.presenter.handleButtonActionForSong(songInfo)
            
        }
        return cell
    }
}

// MARK:- UITableViewDelegate
extension SongListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SongListViewDelegate
extension SongListViewController : SongListViewDelegate {
    
    /// display songs
    func showSongList() {
        
        /// reload tableView
        reloadTableView()
    }
    
    /// display alert with error message
    func showAlertWithMessage(_ message: String) {
        AlertView.showAlertWithTitle(AppTitle, message: message, viewController: self)
    }
    
    /// Reload tableView
    func reloadTableView() {
        DispatchQueue.main.async {
            self.songTableView.reloadData()
        }
    }
    
    /// update on download start
    func updateCellOnDownloadStart(_ song: Song, atIndexPath indexPath: IndexPath) {
        if let cell = songTableView.cellForRow(at: indexPath) as? SongViewCell {
            cell.setActionButtonImageForState(song.downloadState)
            cell.progressLabel.text = Messages.downloading
        }
    }
    
    /// update progress for cell
    func updateDownloadProgess(_ progress: Float, withSongInfo info: SongInfo) {
        if let cell = songTableView.cellForRow(at: info.indexPath) as? SongViewCell {
            cell.setProgress(progress, forSong: info.song)
        }
    }
    
    /// update on complete
    func updateCellOnDownloadComplete(_ song: Song, atIndexPath indexPath: IndexPath) {
        if let cell = songTableView.cellForRow(at: indexPath) as? SongViewCell {
            cell.setActionButtonImageForState(song.downloadState)
        }
    }
}

