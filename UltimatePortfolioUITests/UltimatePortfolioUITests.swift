//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Stefan on 01.04.26.
//

import XCTest

extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement")
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

final class UltimatePortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAppStartsWithNavigationBar() throws {
        // UI tests must launch the application that they test.
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")
    }
    
    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a Filters button on launch.")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a Filters button on launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Issues"].exists, "There should be a Filters button on launch.")
    }
    
    func testNoIssuesAtStart() throws {
        XCTAssertEqual(app.cells.count, 0, "There should be zero list rows initially")
    }
    
    func testCreatingIssues() throws {
        for tapCount in 1...5 {
            app.buttons["New Issues"].tap()
            app.buttons["Issues"].tap()
            
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) list rows")
        }
        
        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()
            
            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) list rows")
        }
    }
    
    func testEditingIssueTitleUpdatesCorrectly() throws {
        XCTAssertEqual(app.cells.count, 0, "There should be no rows initially")
        
        app.buttons["New Issue"].tap()
        
        app.textFields["Enter the issue title here"].tap()
        app.textFields["Enter the issue title here"].clear()
        app.typeText("My New Issue")
        
        app.buttons["Issues"].tap()
        XCTAssertTrue(app.buttons["My New Issue"].exists, "A My New Issue Cell should now exist")
    }
    
    func testEditingIssuePriorityShowsIcon() {
        app.buttons["New Issue"].tap()
        app.buttons["Priority, Medium"].tap()
        app.buttons["High"].tap()
        app.buttons["Issues"].tap()
        
        let identifier = "New issue High Priority"
        XCTAssert(app.images[identifier].exists, "A high priotity icon should be present")
    }
    
    func testAllAwardsShowLockedUpAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()
        
        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            if app.windows.element.frame.contains(award.frame) == false {
                app.swipeUp()
            }
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a locked alert showing this award.")
            app.buttons["Ok"].tap()
        }
    }
}
