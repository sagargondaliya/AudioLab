//
//  DownloadManager.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 07/04/18.
//
//

import UIKit

/**
 Typealias
 */
typealias DownloadProgress = (Float, Int64, String) -> ()
typealias DownloadRemaining = (UInt) -> ()
typealias DownloadComplete = (String, String) -> ()
typealias DownloadError = (String) -> ()

/**
 DownloadManager to download files from server
 */
class DownloadManager : NSObject{

    // MARK : - Singleton
    static let shared = DownloadManager()
    
    // MARK: - Properties
    var session: URLSession!
    var backgroundSession: URLSession!
    
    /// To Store current downloads
    var currentDownloads = [DownloadTaskInfo]()
    
    // MARK: - Initializer
    private override init() {
        super.init()
        
        /// default session
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        /// background session
        let configuration = URLSessionConfiguration.background(withIdentifier: SessionIdentifiers.backgroundSession)
        backgroundSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
}

// MARK: - Public
extension DownloadManager {
    
    /**
     Download File Request
     */
    public func downloadFile(_ url: String, fileName: String, identifier: String, progress: @escaping DownloadProgress, remainingTime: @escaping DownloadRemaining, completed: @escaping DownloadComplete, error: @escaping DownloadError) {
        
        // check network reachability
        if !NetworkReachability.isInternetAvailable(){
            error(Failure.noInternetConnection)
            return
        }
        
        guard var downloadURL = URL(string: url) else { return }
        
        /// check if path extension is not exists or not
        
        if String.isNilOrEmpty(string: downloadURL.pathExtension) {
            let hostName = downloadURL.host ?? ""
            
            // Check if host name is Google Drive then
            // convert to original download url is required
            if hostName == HostName.googleDrive.rawValue {
                downloadURL = HostName.googleDrive.originalDownloadURL(url: downloadURL)!
            }else {
                
                /// file could not be downloaded because of unkown host and extension is not present
                error(Failure.couldNotDownloadFile)
                return
            }
        }
        
        /// create download request
        let request = URLRequest(url: downloadURL)
        
        /// start task
        let downloadTask = self.backgroundSession.downloadTask(with: request)
        downloadTask.setAssociatedObject(identifier)
        
        /// generate file path in document directory
        let fileURL = URL.getDownloadsPath().appendingPathComponent(fileName + ".mp3")
        
        let taskInfo = DownloadTaskInfo(url: downloadURL, fileURL: fileURL, identifier: identifier, downloadTask: downloadTask, progress: progress, remainingTime: remainingTime, completion: completed, error: error)
        
        
        /// add to current downloads
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.currentDownloads.append(taskInfo)
        }
        downloadTask.resume()
     }
    
    /**
     Check if file downloaded for URL
     */
    public func fileDownloadedForURL(_ url: String) {
        
    }
}

// MARK: - URLSessionDelegate
extension DownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let taskInfo = taskInfoForDownloadTask(downloadTask) else { return }
        
        // get progress
        if let progressInfo = taskInfo.progress {
            
            //Showing activity of download when expected bytes is unknown
            var progress = Float(-1.0)
            if totalBytesExpectedToWrite > 0 {
                
                //calculate and update progress
                progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            }
            
            DispatchQueue.main.async {
                progressInfo(progress, totalBytesWritten, taskInfo.taskIdentifier)
            }
        }
        
        /// get remaining time
        if let remainingTime = taskInfo.remainingTime {
            let time = getRemainingTimeForTask(taskInfo, totalBytesTransferred: totalBytesWritten, totalBytesExpected: totalBytesExpectedToWrite)
            DispatchQueue.main.async {
                remainingTime(time)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        /// check response code
        guard let response = downloadTask.response as? HTTPURLResponse, response.statusCode == 200 else { return }
        
        /// get task info
        guard let taskInfo = taskInfoForDownloadTask(downloadTask) else { return }
        
        /// save file at path
        do {
            try FileManager.default.moveItem(at: location, to: taskInfo.fileURL)
            //print("File Saved at: = \(taskInfo.fileURL)")
        }catch {
            print("Error in save file: \(error.localizedDescription)")
        }
        
        /// call completion
        if let completion = taskInfo.completed {
            DispatchQueue.main.async {
                completion(taskInfo.fileURL.lastPathComponent, taskInfo.taskIdentifier)
            }
        }
        
        /// remove from current download
        removeTaskFromCurrentDownloads(taskInfo)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        /// get task info
        guard let taskInfo = taskInfoForDownloadTask(task as! URLSessionDownloadTask), error != nil else { return }
        
        /// call error
        if let errorInfo = taskInfo.failed {
            DispatchQueue.main.async {
                errorInfo(Failure.failedToDownload)
            }
        }

        /// remove from current download
        removeTaskFromCurrentDownloads(taskInfo)
    }
}

// MARK: - Private
extension DownloadManager {
    
    /// Get's task info for download task
    private func taskInfoForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> DownloadTaskInfo? {
        
        //let url = downloadTask.originalRequest?.url?.absoluteString
        let taskIdentifier = downloadTask.associatedObject() as? String ?? ""
        guard let taskInfo = currentDownloads.first(where: { $0.taskIdentifier == taskIdentifier }) else { return nil }
        return taskInfo
    }
    
    /// Remove from current download task
    private func removeTaskFromCurrentDownloads(_ downloadTaskInfo: DownloadTaskInfo) {
        if let index = currentDownloads.index(where: { $0.taskIdentifier == downloadTaskInfo.taskIdentifier }) {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                self.currentDownloads.remove(at: index)
            }
        }
    }
    
    /// Get Remaining Time for task
    private func getRemainingTimeForTask( _ task: DownloadTaskInfo, totalBytesTransferred: Int64, totalBytesExpected: Int64) -> UInt {
     
        if totalBytesExpected < 0 { return 0 }
        
        let timeInterval = Date().timeIntervalSince(task.startDate)
        let speed = Float(totalBytesTransferred) / Float(timeInterval)
        let remainingBytes = totalBytesExpected - totalBytesTransferred
        let remainingTime = Float(remainingBytes) / speed
        return UInt(remainingTime)
    }
}

