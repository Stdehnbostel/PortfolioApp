//
//  SidebarView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 19.01.26.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController

    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""
    @State private var showingAwards = false

    let smartFilters: [Filter] = [.all, .recent]

    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)]
    ) var tags: FetchedResults<Tag>

    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(
                id: tag.tagID,
                name: tag.tagName,
                icon: "tag",
                tag: tag
            )
        }
    }

    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters, content: SmartFilterRow.init)
            }
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    UserFilterRow(filter: filter, rename: rename, delete: delete)
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar {
            SidebarViewToolbar(showingAwards: $showingAwards)
        }
        .alert("Rename Tag", isPresented: $renamingTag) {
            Button("Ok", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $tagName)
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
        .navigationTitle("Filters")
    }

    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }

    func delete(_ filter: Filter) {
        guard let tag = filter.tag else { return }

        dataController.delete(tag)
        dataController.save()
    }

    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }

    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
}

#Preview {
    SidebarView()
        .environmentObject(DataController.preview)
}
