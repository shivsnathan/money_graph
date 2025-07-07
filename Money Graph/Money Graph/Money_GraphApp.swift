//
//  Money_GraphApp.swift
//  Money Graph
//
//  Created by Siva on 27/06/2025.
//

import SwiftUI
import SwiftData

@main
struct Money_GraphApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Statement.self)
    }
}
