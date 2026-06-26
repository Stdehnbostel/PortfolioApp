//
//  PortfolioWidgetBundle.swift
//  PortfolioWidget
//
//  Created by Stefan on 24.06.26.
//

import WidgetKit
import SwiftUI

@main
struct PortfolioWidgetBundle: WidgetBundle {
    var body: some Widget {
        SimplePortfolioWidget()
        ComplexPortfolioWidget()
    }
}
