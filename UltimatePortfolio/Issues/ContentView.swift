//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.01.26.
//

import SwiftUI
import CoreData
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
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
        .onAppear {
            askForReview()
        }
        .onOpenURL(perform: openURL)
    }
    
    func askForReview() {
        if viewModel.shouldRequestReview {
            requestReview()
        }
    }
    
    func openURL(_ url: URL) {
        if url.absoluteString.contains("newIssue") {
            viewModel.dataController.newIssue()
        }
    }
}

#Preview {
    ContentView(dataController: .preview)
}
