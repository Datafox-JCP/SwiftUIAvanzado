//
//  SwiftUIAvanzadoApp.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 07/11/22.
//

import SwiftUI

@main
struct SwiftUIAvanzadoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
