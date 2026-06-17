//
//  SidebarViewToolbar.swift
//  UltimatePortfolio
//
//  Created by Stefan on 21.03.26.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @Binding var showingAwards: Bool
    @State private var showingStore = false

    var body: some View {
        Button(action: tryNewTag) {
            Label("Add Tag", systemImage: "plus")
        }
        .sheet(isPresented: $showingStore) {
            StoreView()
        }
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show Awards", systemImage: "rosette")
        }

        #if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame.circle")
        }
        #endif
    }
    
    func tryNewTag() {
        if dataController.newTag() == false {
            showingStore = true
        }
    }
}

#Preview {
    SidebarViewToolbar(showingAwards: .constant(true))
}
