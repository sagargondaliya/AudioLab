//
//  SongViewCell.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import UIKit

/*
 SongViewCell
 */
class SongViewCell: UITableViewCell {

    
    // MARK:  Outlets
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var progressIndicator: UIProgressView!
    
    //MARK:  Properties
    
    /// click hanlder
    var downloadClicked: ((Song) -> ())?
    
    /// associated song with the cell
    var song: Song?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressLabel.isHidden = true
        containerView.setCornerRadius(radius: 5.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    //MARK:  Helper Methods
    
    /// Sets song information
    func setSongInfo(_ song: Song, atIndexPath indexPath : IndexPath){
        self.song = song
        self.setAssociatedObject(song.id!)
        
        /// set song name
        self.songNameLabel.text = song.name
        
        /// set button's image for state
        setActionButtonImageForState(song.downloadState)
        
        // set progress
        setProgress(song.currentProgress, forSong: song)
    }
    
    /// Sets button's image based on state
    func setActionButtonImageForState(_ state: DownloadStatus) {
        
        switch state {
        case .none:
            actionButton.setImage(#imageLiteral(resourceName: "download"), for: .normal)
            progressIndicator.isHidden = true
        case .started:
            actionButton.setImage(#imageLiteral(resourceName: "download-stop"), for: .normal)
            progressIndicator.isHidden = false
        case .paused:
            actionButton.setImage(#imageLiteral(resourceName: "download"), for: .normal)
            progressIndicator.isHidden = false
        case .done:
            progressIndicator.isHidden = true
            self.setAudioPlayerButton()
        }
        progressLabel.isHidden = (state == .none ||  state == .done)
        actionButton.isHidden = !progressLabel.isHidden
    }
    
    /// Sets audio player button based on status when song download is completed
    func setAudioPlayerButton(){
        
        if AudioPlayerManager.shared.isSongPlaying(song!) {
            actionButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
            return
        }
        actionButton.setImage(#imageLiteral(resourceName: "play-icon"), for: .normal)
    }
    
    /// set progress for song
    func setProgress(_ progress: Float, forSong song: Song) {
        guard let songId = self.associatedObject() as? String, songId == song.id else { return }
        
        progressIndicator.progress = progress
        if progress > 0 && song.downloadState != .done {
            progressIndicator.isHidden = false
            progressLabel.text = String(format: "%.2f %%", progress*100)
        }
        else {
            progressIndicator.isHidden = true
            progressLabel.text = String(format: "%.2f MB", Float(song.totalDownloadsBytes)/Float(bytesToMB))
        }
    }
    
    // MARK:  Action Methods
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        guard let songInfo = self.song, let handler = downloadClicked else { return }
        
        /// call handler
        handler(songInfo)
    }
}
