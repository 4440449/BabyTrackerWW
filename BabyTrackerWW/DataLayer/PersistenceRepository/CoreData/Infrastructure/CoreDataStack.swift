//
//  CoreDataStack.swift
//  Baby tracker
//
//  Created by Max on 29.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//
import CoreData


final class CoreDataStackImpl {
    
    static var shared = CoreDataStackImpl()
    private init() {}
  
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
          let container = NSPersistentCloudKitContainer(name: "Baby_tracker")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()

      // MARK: - Core Data Saving support

      func saveContext () {
          let context = persistentContainer.viewContext
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

enum LocalStorageError: Error {
    
    case synchronize (String)
    case fetch (String)
    case add (String)
    case change (String)
    case delete (String)
}
