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

    var body: some View {
        Button(action: dataController.newTag) {
            Label("Add Tag", systemImage: "plus")
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
}

#Preview {
    SidebarViewToolbar(showingAwards: .constant(true))
}
