//
//  Persistence.swift
//  SwiftUIAvanzado
//
//  Created by Juan Hernandez Pazos on 07/11/22.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "SwiftUIAvanzado")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to initialize Core Data stack \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
