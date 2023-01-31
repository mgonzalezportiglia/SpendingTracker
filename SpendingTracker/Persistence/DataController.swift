//
//  PersistenceController.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 31/01/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    // with this set up, we say to Core Data wich Data Model we want to use
    let container = NSPersistentContainer(name: "SpendingTracker")

    // we create a initializer to loads our stored data
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
