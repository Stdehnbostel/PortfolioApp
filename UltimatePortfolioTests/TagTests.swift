//
//  TagTests.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 26.03.26.
//

import CoreData
import Testing
@testable import UltimatePortfolio

final class TagTests: UltimatePortfolioTestsBaseTestCases {

    @Test func testCreatingTagsAndIssues() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let tag = Tag(context: managedObjectContext)

            for _ in 0..<targetCount {
                let issue = Issue(context: managedObjectContext)
                tag.addToIssues(issue)
            }
        }

        #expect(dataController.count(for: Tag.fetchRequest()) == targetCount, "there should be \(targetCount) tags")
        #expect(dataController.count(for: Issue.fetchRequest()) == targetCount * targetCount, "there should be \(targetCount * targetCount) issues")
    }

    @Test func testDeletingTagsDoesNotDeleteIssues() throws {
        dataController.createSampleData()

        let request = NSFetchRequest<UltimatePortfolio.Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)

        dataController.delete(tags[0])

        #expect(dataController.count(for: Tag.fetchRequest()) == 4, "There should be 4 tags after deleting 1 from our sample data.")
        #expect(dataController.count(for: Issue.fetchRequest()) == 50, "There should be 50 issues in total.")
    }
}
