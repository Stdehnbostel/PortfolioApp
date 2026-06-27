//
//  NumberBadge.swift
//  UltimatePortfolio
//
//  Created by Stefan on 27.06.26.
//

import SwiftUI

extension View {
    func numberBadge(_ number: Int) -> some View {
        #if os(watchOS)
        self
        #else
        self.badge(number)
        #endif
    }
}
