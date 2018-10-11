//
//  Song+CoreDataProperties.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//
//

import Foundation
import CoreData

extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var audioURL: String?
    @NSManaged public var fileName: String?
    
    // MARK: - Init
    convenience init(dictionary: [String: AnyObject]) {
        self.init(context: DataBaseManager.shared.context)
        
        id = dictionary[ResponseKey.id] as? String
        name = dictionary[ResponseKey.name] as? String
        audioURL = dictionary[ResponseKey.audioURL] as? String
        fileName = ""
    }
}
