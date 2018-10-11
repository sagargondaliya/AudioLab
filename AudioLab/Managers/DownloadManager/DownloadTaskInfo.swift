//
//  DownloadTaskInfo.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 07/04/18.
//
//

import Foundation

/**
 Download task info
 */
struct DownloadTaskInfo {
    
    /// Properties : File info
    var url: URL
    var fileURL: URL
    
    /// Progress Info
    var progress: DownloadProgress?
    var remainingTime: DownloadRemaining?
    var completed: DownloadComplete?
    var failed: DownloadError?
    
    /// Task info
    var taskIdentifier: String
    var startDate: Date
    var downloadTask: URLSessionDownloadTask
    var downloadedData: Data?
    
    // MARK: - Init
    init(url: URL, fileURL: URL, identifier: String, downloadTask: URLSessionDownloadTask, progress: DownloadProgress?, remainingTime: DownloadRemaining?, completion: DownloadComplete?, error: DownloadError?) {
     
        self.url = url
        self.fileURL = fileURL
        self.taskIdentifier = identifier
        self.downloadTask = downloadTask
        self.progress = progress
        self.remainingTime = remainingTime
        self.completed = completion
        self.failed = error
        startDate = Date()
    }
}
