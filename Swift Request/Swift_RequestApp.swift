//
//  Swift_RequestApp.swift
//  Swift Request
//
//  Created by Jonathan Dowdell on 12/19/21.
//

import SwiftUI

@main
struct Swift_RequestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
