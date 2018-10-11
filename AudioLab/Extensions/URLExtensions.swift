//
//  URLExtensions.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 07/04/18.
//
//

import Foundation
import ObjectiveC
    
extension URL {
    
    /// Get Query parameter value
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
    
    /// Get Downloads folder path
    static func getDownloadsPath() -> URL {
        let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let downloadsURL = directoryURL.appendingPathComponent("Downloads", isDirectory: true)
        if !FileManager.default.fileExists(atPath: downloadsURL.path) {
            try! FileManager.default.createDirectory(at: downloadsURL, withIntermediateDirectories: false, attributes: nil)
        }
        return downloadsURL
    }
}
