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
    }
}

