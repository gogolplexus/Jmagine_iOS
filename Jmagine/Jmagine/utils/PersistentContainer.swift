//
//  PersistentContainer.swift
//  Jmagine
//
//  Created by mbds on 24/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
