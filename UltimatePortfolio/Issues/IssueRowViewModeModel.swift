//
//  IssueRowViewModeModel.swift
//  UltimatePortfolio
//
//  Created by Stefan on 24.05.26.
//

import Combine
import Foundation

extension IssueRow {
    class ViewModel: ObservableObject {
        let issue: Issue
        
        var iconOpacity: Double {
            issue.priority == 2 ? 1 : 0
        }
        
        var iconIdentifier: String {
            issue.priority == 2 ? "\(issue.issueTitle) High Priority" : ""
        }
        
        var accessibilityHint: String {
            issue.priority == 2 ? "High priority" : ""
        }
        
        var createnDate: String {
            issue.issueCreationDate.formatted(date: .numeric, time: .omitted)
        }
        
        var accessibilityCreatenDate: String {
            issue.issueCreationDate.formatted(date: .abbreviated, time: .omitted)
        }
        
        init(issue: Issue) {
            self.issue = issue
        }
    }
}
