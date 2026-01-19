//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.01.26.
//

import SwiftUI
import CoreData

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(
                    \.managedObjectContext,
                     dataController.container.viewContext
            )
            .environmentObject(dataController)
        }
    }
}
