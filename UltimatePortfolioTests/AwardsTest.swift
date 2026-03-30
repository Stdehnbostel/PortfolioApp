//
//  AwardsTest.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 27.03.26.
//

import CoreData
import Testing
@testable import UltimatePortfolio

class AwardsTest: UltimatePortfolioTestsBaseTestCases {
    let awards = Award.allAwards

    @Test func awardIdEqualsName() {
        for award in awards {
            #expect(award.id == award.name, "Award Id should always match its name.")
        }
    }
    
    @Test func newUserHasUnlockedNoAwards() {
        for award in awards {
            #expect(dataController.hasEarned(award: award) == false, "new user shold not have earned any awards.")
        }
    }
    
    @Test func creatingIssuesUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        
        for (count, value) in values.enumerated() {
            var issues: [UltimatePortfolio.Issue] = []
            
            for _ in 0..<value {
                let issue = UltimatePortfolio.Issue(context: managedObjectContext)
                issues.append(issue)
            }
            
            let matches = awards.filter { award in
                award.criterion == "issues" && dataController.hasEarned(award: award)
            }
            dataController.deleteAll()
            print("matches count: \(matches.count)")
            #expect(matches.count == count + 1, "Adding \(value) issues should unlock \(count + 1) awards.")
        }
    }
    
    // run on main actor to prevent issues with multithreaded testing
    @MainActor
    @Test func closingIssuesUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        
        for (count, value) in values.enumerated() {
            var issues: [UltimatePortfolio.Issue] = []
            
            for _ in 0..<value {
                let issue = UltimatePortfolio.Issue(context: managedObjectContext)
                issue.completed = true
                issues.append(issue)
            }
            
            let matches = awards.filter { award in
                award.criterion == "closed" && dataController.hasEarned(award: award)
            }
            dataController.deleteAll()
            print("matches count: \(matches.count)")
            #expect(matches.count == count + 1, "Completing \(value) issues should unlock \(count + 1) awards.")
        }
    }
}
