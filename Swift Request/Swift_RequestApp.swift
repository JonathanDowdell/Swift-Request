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
    let accentColor = AccentColor.shared

    var body: some Scene {
        WindowGroup {
            GlobalThemeView(mainViewModel: MainViewModel(context: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { output in
                    try? persistenceController.container.viewContext.save()
                }
        }
    }
}
