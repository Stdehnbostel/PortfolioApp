//
//  DevelopmentTests.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 30.03.26.
//

import CoreData
import Testing
@testable import UltimatePortfolio

class DevelopmentTests: UltimatePortfolioTestsBaseTestCases {

    @MainActor
    @Test func sampleDataCreationWorks() {
        dataController.createSampleData()
        
        #expect(dataController.count(for: UltimatePortfolio.Tag.fetchRequest()) == 5, "There should be 5 smaple tags.")
        #expect(dataController.count(for: UltimatePortfolio.Issue.fetchRequest()) == 50, "There should be 50 smaple issues.")
    }

    @Test func deleteAllDataWorks() {
        dataController.createSampleData()
        dataController.deleteAll()
        
        #expect(dataController.count(for: UltimatePortfolio.Tag.fetchRequest()) == 0, "There should be no smaple tags after deletion.")
        #expect(dataController.count(for: UltimatePortfolio.Issue.fetchRequest()) == 0, "There should be no smaple issues after deletion.")
    }
    
    @Test func newlyCreatedExampleTagHasZeroIssues() {
        let tag = UltimatePortfolio.Tag.example
        
        #expect(tag.issues?.count == 0)
    }
    
    @Test func NewlyCreatedExampleIssueHasHighPriority() {
        let issue = UltimatePortfolio.Issue.example
        
        #expect(issue.priority == 2, "The example issue should be set to high priority.")
    }
}
