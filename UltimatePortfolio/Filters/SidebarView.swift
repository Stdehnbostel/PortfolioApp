//
//  SidebarView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 19.01.26.
//

import SwiftUI

struct SidebarView: View {
    let smartFilters: [Filter] = [.all, .recent]
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    @StateObject private var viewModel: ViewModel
    @State private var showingAwards = false
    
    var body: some View {
        List(selection: $viewModel.dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters, content: SmartFilterRow.init)
            }
            Section("Tags") {
                ForEach(viewModel.tagFilters) { filter in
                    UserFilterRow(filter: filter, rename: viewModel.rename, delete: viewModel.delete)
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .macFrame(minWidth: 220)
        .toolbar {
            SidebarViewToolbar(showingAwards: $showingAwards)
        }
        .alert("Rename Tag", isPresented: $viewModel.renamingTag) {
            Button("Ok", action: viewModel.completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $viewModel.tagName)
        }
        .sheet(isPresented: $showingAwards) { AwardsView(dataController: viewModel.dataController) }
        .navigationTitle("Filters")
    }
}

#Preview {
    SidebarView(dataController: .preview)
}
