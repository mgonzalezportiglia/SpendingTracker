//
//  SpendingTrackerApp.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 19/01/2023.
//

import SwiftUI

@main
struct SpendingTrackerApp: App {
    //let persistenceController = PersistenceController.shared
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
