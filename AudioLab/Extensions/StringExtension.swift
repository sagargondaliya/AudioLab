//
//  StringExtension.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 07/04/18.
//
//

import Foundation

extension String {
    
    /// Checks if string is nil or empty
    static func isNilOrEmpty(string: String?) -> Bool {
        guard let value = string else { return true }
        return value.isEmpty
    }
    
    /// Get document directory path url for given string
    static func documentDirectoryPath(forFileName name: String) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths.first! as NSString
        return documentPath.appendingPathComponent(name) as String
    }
}
