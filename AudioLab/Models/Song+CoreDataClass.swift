//
//  Song+CoreDataClass.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//

import Foundation
import CoreData

@objc(Song)
public class Song: NSManagedObject {

    // MARK: - Custom Properties
    
    /// stores current progress
    var currentProgress: Float = 0.0
    
    /// store downloaded bytes for song
    var totalDownloadsBytes: Int64 = 0
    
    /// manage download state
    var downloadState : DownloadStatus = .none
    
    /// File URL Path
    var fileURLPath: URL? {
        guard let name = fileName, !name.isEmpty else { return nil }
        
        let path = URL.getDownloadsPath().appendingPathComponent(name)
        return URL(fileURLWithPath: path.path)
    }
    
    /// checks if download is completed
    var downloadCompleted: Bool {
        
        guard let path = fileURLPath else { return false }
        return FileManager.default.fileExists(atPath: path.path)
    }
}
