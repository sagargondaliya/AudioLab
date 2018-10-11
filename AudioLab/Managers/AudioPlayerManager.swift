//
//  AudioPlayerManager.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation
import AVFoundation

/**
 AudioPlayerManager
 */
final class AudioPlayerManager: NSObject {
    
    // MARK : - Singleton
    static let shared = AudioPlayerManager()
    
    // MARK : Properties
    var player: AVAudioPlayer?
    var currentSong: Song?
    
    // MARK: - Initializer
    private override init() {
        super.init()
    }
    
    /// Player - Play/Pause Audio method
    public func playPauseAudio(_ song: Song) {
        
        /// stop current playing song if any
        if let player = player, currentSong?.id == song.id {
            
            /// if playing then pause player
            if player.isPlaying {
                pausePlayer()
                return
            }
            
            /// resume play
            player.play()
            return
        }
        
        /// stop current playing song
        stopPlayer()
        
        /// check if file exists for play
        if let path = song.fileURLPath {
            
            /// preapre audio player
            preparePlayerWithAudioPath(path)
            player?.play()
            currentSong = song
        }
    }
    
    /// Stops current playing song
    public func stopPlayer() {
        
        currentSong = nil
        player?.stop()
    }
    
    /// Pause current playing song
    public func pausePlayer() {
        player?.pause()
    }
    
    /// checks if song is playing
    public func isSongPlaying(_ song: Song) -> Bool  {
        
        if currentSong?.id != song.id { return false }
        return player?.isPlaying ?? false
    }
    
    // MARK: - Private
    
    /// Prepare player to play audio
    private func preparePlayerWithAudioPath(_ path : URL) {
        do {
            
            player = try AVAudioPlayer(contentsOf: path)
            player?.delegate = self
            
            /// prepare player to play song
            player?.prepareToPlay()
            
            /// Create an audio session
            let audioSession = AVAudioSession.sharedInstance()
            do {
                /// Set session as playback music
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                
            } catch let sessionError {
                print("Audio Session Error : \(sessionError)")
            }
            
        } catch let error{
            player = nil
            AlertView.showAlertWithTitle(AppTitle, message: Failure.failedToPlayFile, viewController: nil)
            print("Player Error : \(error)")
        }
    }
    
}

// MARK: - AVAudioPlayerDelegate
extension AudioPlayerManager : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: Notifications.AudioPlayerDidFinish, object: nil)
    }
}
