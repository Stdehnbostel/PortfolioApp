//
//  AwardsViewModel.swift
//  UltimatePortfolio
//
//  Created by Stefan on 24.05.26.
//

import Combine
import SwiftUI

extension AwardsView {
    class ViewModel: ObservableObject {
        let dataController: DataController
        @Published var selectedAward = Award.example
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        
        func color(for award: Award) -> Color {
            dataController.hasEarned(award: award) ? Color(award.color) :  .secondary.opacity(0.5)
        }
        
        func label(for award: Award) -> LocalizedStringKey {
            dataController.hasEarned(award: award) ? "Unlocked \(award.name)" : "Locked"
        }
        
        func hasEarned(award: Award) -> Bool {
            dataController.hasEarned(award: award)
        }
    }
}
