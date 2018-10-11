//
//  Enums.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation

/*
 Download Status
 */
enum DownloadStatus: Int {
    case none = 0, started, paused, done
}

/*
 Play Status
 */
enum PlayStatus: Int {
    case none = 0, playing, paused
}

/**
 HTTP Request type
 */
enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

/**
 HTTP Header Fields
 */
enum HTTPHeader: String {
    case accept             = "Accept"
    case contentType        = "Content-Type"
}

/**
 HTTP Header Values
 */
enum HTTPHeaderValue: String {
    case applicationJSON   = "application/json"
}


/**
 Host Names
 */
enum HostName: String {
    case googleDrive = "drive.google.com"
    
    /// get original download url
    func originalDownloadURL(url: URL) -> URL? {
        
        var fileId = url.valueOf("id")
        if String.isNilOrEmpty(string: fileId) {
            
            if let index = url.pathComponents.index(where: { $0 == "d" }) {
                fileId = url.pathComponents[index+1]
            }
        }
        
        if let downloadId = fileId {
            let urlString = String(format: "https://%@/uc?id=%@&export=download", url.host!, downloadId)
            return URL(string: urlString)!
        }
        return nil
    }
}

