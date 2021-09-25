//
//  logItApp.swift
//  Shared
//
//  Created by Esti Tweg on 25/9/21.
//

import SwiftUI

@main
struct logItApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
