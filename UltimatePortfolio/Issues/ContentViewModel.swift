//
//  ContentViewModel.swift
//  UltimatePortfolio
//
//  Created by Stefan on 24.05.26.
//

import Foundation
import Combine

extension ContentView {
    @dynamicMemberLookup
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        var shouldRequestReview: Bool {
            if dataController.count(for: Tag.fetchRequest()) >= 5 {
                let reviewRequestCount = UserDefaults.standard.integer(forKey: "reviewRequestCount")
                UserDefaults.standard.set(reviewRequestCount + 1, forKey: "reviewRequestCount")
                
                if reviewRequestCount.isMultiple(of: 10) {
                    return true
                }
            }
            
            return false
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        subscript<Value>(dynamicMember keyPath: KeyPath<DataController, Value>) -> Value {
            dataController[keyPath: keyPath]
        }
        
        subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<DataController, Value>) -> Value {
            get { dataController[keyPath: keyPath] }
            set { dataController[keyPath: keyPath] = newValue }
        }
        
        func delete(_ offset: IndexSet) {
            let issues = dataController.issuesForSelectedFilter()

            for offset in offset {
                let issue = issues[offset]
                dataController.delete(issue)
            }
        }
        
        func newIssue() {
            dataController.newIssue()
        }
        
        func openURL(_ url: URL) {
            if url.absoluteString.contains("newIssue") {
                newIssue()
            } else if let issue = dataController.issue(with: url.absoluteString) {
                dataController.selectedIssue = issue
                dataController.selectedFilter = .all
            }
        }
    }
}

