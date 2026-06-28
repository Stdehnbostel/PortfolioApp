//
//  DataController-Testing.swift
//  UltimatePortfolio
//
//  Created by Stefan on 28.06.26.
//

import SwiftUI

extension DataController {
    func checkForTestEnvironment() {
        // Enable Ui tets to start from a clear slate
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            self.deleteAll()
        }
        #endif
    }
}
