//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.01.26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel: ViewModel
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(selection: $viewModel.selectedIssue) {
            ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Issues")
        .searchable(
            text: $viewModel.filterText,
            tokens: $viewModel.filterTokens,
            suggestedTokens: .constant(viewModel.suggestedFilterTokens),
            prompt: "Filter issues or type # to add tags") { tag in
                Text(tag.tagName)
        }
        .toolbar {
            ContentViewToolbar()
        }
    }
}

#Preview {
    ContentView(dataController: .preview)
}
