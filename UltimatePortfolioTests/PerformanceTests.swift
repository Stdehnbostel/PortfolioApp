//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 31.03.26.
//

import CoreData
@testable import UltimatePortfolio
import XCTest

class PerformanceTests: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
    

    func testAwardCalculationPerformance() {
        for _ in 0..<100 {
            dataController.createSampleData()
        }
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks that the awards count is constant. Change that, if you add awards.")
        
        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
