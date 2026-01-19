//
//  Filter.swift
//  UltimatePortfolio
//
//  Created by Stefan on 19.01.26.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var tag: Tag?
    
    static var all = Filter(id: UUID(), name: "All issues", icon: "tray")
    static var recent = Filter(
        id: UUID(),
        name: "Recent issues",
        icon: "clock",
        minModificationDate: Date.now.addingTimeInterval(-86_400 * 7)
    )
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
