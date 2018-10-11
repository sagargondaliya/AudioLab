//
//  DataBaseManager.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation
import CoreData

/**
 DataBaseManager
 */
final class DataBaseManager{
    
    // MARK: - Singleton
    static let shared = DataBaseManager()
    
    /// The value to use for `fetchBatchSize` when fetching objects.
    var defaultFetchBatchSize = 50
    
    /// context for the database
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "AudioLab")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Initializer
    private init() {
        //super.init()
    }
    
    // MARK: - Core Data Saving support
    public func saveContext () {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    /// Fetch data from database
    public func fetchObjects<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        
        // create fetch request
         var result = [T]()
        
        // to synchrinize calls
        context.performAndWait {
            let request = NSFetchRequest<T>(entityName: String(describing: entity))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            request.fetchBatchSize = defaultFetchBatchSize
            
            do {
                result = try context.fetch(request)
            }
            catch let error as NSError {
                print("Fetch Error : \(error.localizedDescription)")
            }
        }
        return result
    }
    
    /// Update Song details in database
    public func updateSongDetails(_ song: Song) {
        
        let predicate = NSPredicate(format: "id == %@", song.id!)
        if let songInfo = fetchObjects(entity: Song.self, predicate: predicate, sortDescriptors: nil).first {
            
            // update file name if not nil
            if !String.isNilOrEmpty(string: song.fileName) {
                songInfo.fileName = song.fileName
            }

            // update download status
            songInfo.downloadState = .done
            
        }
    }
    
}
