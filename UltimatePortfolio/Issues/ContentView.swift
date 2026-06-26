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
    
    private let newIssueActivity = "com.stdehnbostel.UltimatePortfolio.newIssue"
    
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
        .macFrame(minWidth: 220)
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
        .onOpenURL(perform: viewModel.openURL)
        .userActivity(newIssueActivity) { activity in
            #if !os(macOS)
            activity.isEligibleForPrediction = true
            #endif
            activity.title = "New Issue"
        }
        .onContinueUserActivity(newIssueActivity, perform: resumeActivity)
    }
    
    func askForReview() {
        if viewModel.shouldRequestReview {
            requestReview()
        }
    }
    
    func resumeActivity(_ userActivity: NSUserActivity) {
        viewModel.newIssue()
    }
}

#Preview {
    ContentView(dataController: .preview)
}
