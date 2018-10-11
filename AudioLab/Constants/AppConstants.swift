//
//  AppConstants.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation

let AppTitle = "AudioLab"

/* Network URLs */
struct NetworkURLs {

    static let fetchSongs  = "https://gist.githubusercontent.com/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/9302546abb4552605d71d8da51d1f97bc039d431/Songs.json"
}

/* Background session identifiers */
struct SessionIdentifiers {
    static let backgroundSession = "backgroundDownloadSession"
}

/* Cell Identifiers */
struct CellIdentifiers {
    static let songViewCell         = "songViewCell"
}

/* Response Keys */
struct ResponseKey {
    static let data     = "data"
    static let id       = "id"
    static let name     = "name"
    static let audioURL = "audioURL"
}

/* Entity */
struct Entity {
    static let song     = "Song"
}

/* Notification */
struct Notifications {
    static let AudioPlayerDidFinish = NSNotification.Name(rawValue: "AudioPlayerDidFinishName")
}

// convert bytes to MB
let bytesToMB = (1024*1024)
