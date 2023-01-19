//
//  SpendingTrackerApp.swift
//  SpendingTracker
//
//  Created by Matias Gonzalez Portiglia on 19/01/2023.
//

import SwiftUI

@main
struct SpendingTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
