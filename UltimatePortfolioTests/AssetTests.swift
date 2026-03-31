//
//  AssetTests.swift
//  UltimatePortfolioTests
//
//  Created by Stefan on 26.03.26.
//

import Testing
@testable import UltimatePortfolio
import SwiftUI

struct AssetTests {
    let allColours = ["Dark Blue", "Dark Gray", "Gold", "Gray", "Green",
    "Light Blue", "Midnight", "Orange", "Pink", "Purple", "Red", "Teal"]

    @Test func testColorsExist() async throws {
        for color in allColours {
            #expect(UIColor(named: color) != nil, "Failed to load '\(color)' from asset catalog")
        }
    }

    @Test func testAwardsLoadCorrectly() {
        #expect(Award.allAwards.isEmpty == false, "Failed to load awards from JSON")
    }
}
