//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.01.26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        List(selection: $dataController.selectedIssue) {
            ForEach(dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Issues")
        .searchable(
            text: $dataController.filterText,
            tokens: $dataController.filterTokens,
            suggestedTokens: .constant(dataController.suggestedFilterTokens),
            prompt: "Filter issues or type # to add tags") { tag in
                Text(tag.tagName)
        }
        .toolbar {
            ContentViewToolbar()
        }
    }

    func delete(_ offset: IndexSet) {
        let issues = dataController.issuesForSelectedFilter()

        for offset in offset {
            let issue = issues[offset]
            dataController.delete(issue)
        }
    }
}

#Preview {
    ContentView()
}
