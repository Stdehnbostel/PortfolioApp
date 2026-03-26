//
//  UltimatePortfolioTests.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 26.03.26.
//

import CoreData
import Testing
@testable import UltimatePortfolio

struct UltimatePortfolioTestsBaseTestCases {
    var dataController: DataController
    var managedObjectContext: NSManagedObjectContext
    
    init() {
        let dataController = DataController(inMemory: true)
        self.dataController = dataController
        self.managedObjectContext = dataController.container.viewContext
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
