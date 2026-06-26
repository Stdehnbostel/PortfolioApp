//
//  InlineNavigationBar.swift
//  UltimatePortfolio
//
//  Created by Stefan on 26.06.26.
//

import SwiftUI

extension View {
    func inlineNavaigationBar() -> some View {
        #if os(macOS)
        self
        #else
        self.navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
