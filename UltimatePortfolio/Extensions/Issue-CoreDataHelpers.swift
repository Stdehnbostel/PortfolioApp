//
//  Issue-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Stefan on 19.01.26.
//

import Foundation
import CoreData

extension Issue {
    var issueTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }

    var issueContent: String {
        get { content ?? ""}
        set { content = newValue }
    }

    var issueCreationDate: Date {
        creationDate ?? .now
    }

    var issueModificationDate: Date {
        modificationDate ?? .now
    }

    static var example: Issue {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let issue = Issue(context: viewContext)
        issue.title = "Example Issue"
        issue.content = "This is an example issue."
        issue.priority = 2
        issue.creationDate = .now

        return issue
    }

    var issueTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }

    var issueTagsList: String {
        guard let tags else {
            return "No tags"
        }

        if tags.count == 0 {
            return "No tags"
        } else {
            return issueTags.map(\.tagName).formatted()
        }
    }

    var issueStatus: String {
        if completed {
            "Closed"
        } else {
            "Open"
        }
    }
}

extension Issue: Comparable {
    public static func < (lhs: Issue, rhs: Issue) -> Bool {
        let left = lhs.issueTitle.localizedLowercase
        let right = rhs.issueTitle.localizedLowercase

        if left == right {
            return lhs.issueCreationDate < rhs.issueCreationDate
        }

        return left < right
    }
}
