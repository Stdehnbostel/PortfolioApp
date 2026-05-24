//
//  ContentViewModel.swift
//  UltimatePortfolio
//
//  Created by Stefan on 24.05.26.
//

import Foundation
import Combine

extension ContentView {
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
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

