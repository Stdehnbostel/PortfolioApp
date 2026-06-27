//
//  SidebarViewToolbar.swift
//  UltimatePortfolio
//
//  Created by Stefan on 21.03.26.
//

import SwiftUI

struct SidebarViewToolbar: ToolbarContent {
    @EnvironmentObject var dataController: DataController
    @Binding var showingAwards: Bool
    @State private var showingStore = false

    var body: some ToolbarContent {
        ToolbarItem(placement: .automaticOrTrailing) {
            Button(action: tryNewTag) {
                Label("Add Tag", systemImage: "plus")
            }
            .sheet(isPresented: $showingStore) {
                StoreView()
            }
            .help("Add Tag")
        }
        
        ToolbarItem(placement: .automaticOrLeading) {
            Button {
                showingAwards.toggle()
            } label: {
                Label("Show Awards", systemImage: "rosette")
            }
            .help("Show Awards")
        }

        #if DEBUG
        ToolbarItem(placement: .automatic) {
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame.circle")
            }
        }
        #endif
    }
    
    func tryNewTag() {
        if dataController.newTag() == false {
            showingStore = true
        }
    }
}
