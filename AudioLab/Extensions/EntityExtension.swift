//
//  EntityExtension.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation
import CoreData

extension NSEntityDescription {
    
    /// create new Song entity from dictionary
    static func createNewSongFromDictionary(_ dictionary: [String: AnyObject]) -> Song {
        
        let song = self.insertNewObject(forEntityName: Entity.song, into: DataBaseManager.shared.context)
        song.setValuesForKeys(dictionary)
        return song as! Song 
    }
}
